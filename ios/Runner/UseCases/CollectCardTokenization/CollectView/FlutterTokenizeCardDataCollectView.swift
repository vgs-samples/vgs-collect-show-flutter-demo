//
//  FlutterTokenizeCardDataCollectView.swift
//  Runner

import Foundation
import Flutter
import UIKit
import VGSCollectSDK

/// FlutterPlatformView wrapper for Collect view.
class FlutterTokenizeCardDataCollectView: NSObject, FlutterPlatformView {

  // MARK: - Vars

  /// VGS Collect instance.
  var vgsCollect: VGSCollect?

  /// Collect view.
  let collectView: CustomCardDataCollectView

  /// Flutter binary messenger.
  let messenger: FlutterBinaryMessenger

  /// Flutter method channel.
  let channel: FlutterMethodChannel

  /// View id.
  let viewId: Int64

  /// CardIO controller.
  let cardIOController: VGSCardIOScanController

  // MARK: - Initialization.

  /// Initializatier.
  /// - Parameters:
  ///   - messenger: `FlutterBinaryMessenger` object, Flutter binary messenger.
  ///   - frame: `CGRect` object, view frame.
  ///   - viewId: `Int64` object, view unique id.
  ///   - args: `Any?` object, arguments.
  init(messenger: FlutterBinaryMessenger,
       frame: CGRect,
       viewId: Int64,
       args: Any?) {
    self.messenger = messenger
    self.viewId = viewId
    self.collectView = CustomCardDataCollectView()

    // Create flutter method channel.
    self.channel = FlutterMethodChannel(name: "tokenize-card-collect-form-view/\(viewId)",
                                        binaryMessenger: messenger)
    self.cardIOController = VGSCardIOScanController()

    super.init()
    self.cardIOController.delegate = self

    // Handle methods from Flutter.
    channel.setMethodCallHandler({[weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      switch call.method {
      case "configureCollect":
        self?.configCollect(with: call.arguments)
        result(nil)
      case "showKeyboard":
        self?.collectView.cardHolderField.becomeFirstResponder()
        result(nil)
      case "tokenizeCard":
        self?.tokenizeCard(with: result)
      case "isFormValid":
        self?.validateForm(with: result)
      case "hideKeyboard":
        self?.collectView.endEditing(true)
        result(nil)
      case "presentCardIO":
        let vc = UIApplication.shared.windows.first!.rootViewController!
        self?.cardIOController.presentCardScanner(on: vc, animated: true, modalPresentationStyle: .fullScreen, completion: nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    })
  }

  // MARK: - Event channel

  // MARK: - FlutterPlatformView

  // no:doc
  public func view() -> UIView {
    return collectView
  }

  // MARK: - Helpers

  /// Configure VGS Collect.
  /// - Parameter args: `Any?` object, method arguments.
  private func configCollect(with args: Any?) {
    guard let payload = args as? [String:Any],
          let vaultID = payload["vault_id"] as? String,
          let environment = payload["environment"] as? String else {
      assertionFailure("Invalid config")
      return
    }

    let vgsCollect = VGSCollect(id: vaultID, environment: environment)
    self.collectView.configureFieldsWithCollect(vgsCollect)
    self.vgsCollect = vgsCollect

    // Observing text fields. The call back return all textfields with updated states. You also can you VGSTextFieldDelegate
    vgsCollect.observeStates = { [weak self] form in

      var newText = ""

      form.forEach({ textField in
        newText.append(textField.state.description)
        newText.append("\n")
      })
      var payload = [String: Any]()
      payload["STATE_DESCRIPTION"] = newText
      self?.channel.invokeMethod("stateDidChange", arguments: payload)
    }
  }

  /// Validate form with Flutter result complection block.
  /// - Parameter result: `FlutterResult` object, flutter results.
  private func validateForm(with result: @escaping FlutterResult) {
    let invalidFields = vgsCollect!.textFields.compactMap{$0.state.isValid}.filter({$0 == false})
    result(invalidFields.isEmpty)
  }

  /// Tokenize card with Flutter result completion block object.
  /// - Parameter result: `FlutterResult` object, Flutter result completion block object.
  private func tokenizeCard(with result: @escaping FlutterResult) {

    vgsCollect?.tokenizeData { [weak self](response) in
      switch response {
      case .success(_, let resultBody, _):
        let response = (String(data: try! JSONSerialization.data(withJSONObject: resultBody!, options: .prettyPrinted), encoding: .utf8)!)

        let payload: [String: Any] = [
          "STATUS": "SUCCESS",
          "DATA": response
        ]
        result(payload)

        return
      case .failure(let code, _, _, let error):
        switch code {
        case 400..<499:
          // Wrong request. This also can happend when your Routs not setup yet or your <vaultId> is wrong
          let errorText = "Error: Wrong Request, code: \(code)"
          let payload: [String: Any]  = [
            "STATUS": "FAILED",
            "ERROR": errorText
          ]
          result(payload)
          return
        case VGSErrorType.inputDataIsNotValid.rawValue:
          var errorText = "Input data is not valid"
          if let error = error as? VGSError {
            errorText = "Error: Input data is not valid. Details:\n \(error)"
          }
          let payload: [String: Any]  = [
            "STATUS": "FAILED",
            "ERROR": errorText
          ]
          result(payload)
          return
        default:

          print("Submit request error: \(code), \(String(describing: error))")

          let payload: [String: Any]  = [
            "STATUS": "FAILED",
            "ERROR": "Error: Something went wrong. Code: \(code)"
          ]
          result(payload)
          return
        }
      }
    }
  }
}

// MARK: - VGSCardIOScanControllerDelegate

// no:doc
extension FlutterTokenizeCardDataCollectView: VGSCardIOScanControllerDelegate {

  // no:doc
  func userDidFinishScan() {
    self.cardIOController.dismissCardScanner(animated: true, completion: {
      self.channel.invokeMethod("userDidFinishScan", arguments: nil)
    })
  }

  // no:doc
  func userDidCancelScan() {
    self.cardIOController.dismissCardScanner(animated: true, completion: {
      self.channel.invokeMethod("userDidCancelScan", arguments: nil)
    })
  }

  // no:doc
  func textFieldForScannedData(type: CradIODataType) -> VGSTextField? {
    switch type {
    case .cardNumber:
      return collectView.cardNumberField
    case .expirationDateLong:
      return collectView.expDateField
    case .cvc:
      return collectView.cvcTextField
    default:
      return nil
    }
  }
}
