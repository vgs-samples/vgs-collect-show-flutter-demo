//
//  FlutterCardDataCollectView.swift
//  Runner

import Foundation
import Flutter
import UIKit
import VGSCollectSDK

/// FlutterPlatformView wrapper for Collect view.
class FlutterCardDataCollectView: NSObject, FlutterPlatformView {

  // MARK: - Vars

  /// VGS Collect instance.
  var vgsCollect: VGSCollect?

  /// Collect view.
  let collectView: CollectCardDataView

  /// Flutter binary messenger.
  let messenger: FlutterBinaryMessenger

  /// Flutter method channel.
  let channel: FlutterMethodChannel

  /// View id.
  let viewId: Int64

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
    self.collectView = CollectCardDataView()

    // Create flutter method channel.
    self.channel = FlutterMethodChannel(name: "card-collect-for-show-form-view/\(viewId)",
                                       binaryMessenger: messenger)

    super.init()

    // Handle methods from Flutter.
    channel.setMethodCallHandler({[weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      switch call.method {
      case "configureCollect":
        self?.configCollect(with: call.arguments)
        result(nil)
      case "redactCard":
        self?.redactCard(with: result)
      case "isFormValid":
        self?.validateForm(with: result)
      case "showKeyboard":
        self?.collectView.cardHolderField.becomeFirstResponder()
        result(nil)
      case "hideKeyboard":
        self?.collectView.endEditing(true)
        result(nil)
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
        //FlutterCollectChannel.shared.eventSink?(payload)
    }
  }

  /// Validate form with Flutter result complection block.
  /// - Parameter result: `FlutterResult` object, flutter results.
  private func validateForm(with result: @escaping FlutterResult) {
    let invalidFields = vgsCollect!.textFields.compactMap{$0.state.isValid}.filter({$0 == false})
    result(invalidFields.isEmpty)
  }

  /// Redact card with Flutter result completion block object.
  /// - Parameter result: `FlutterResult` object, Flutter result completion block object.
  private func redactCard(with result: @escaping FlutterResult)  {
    vgsCollect?.sendData(path: "/post", extraData: nil) {[weak self](response) in
      switch response {
      case .success(_, let data, _):
        if let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {

          print("SUCCESS: \(jsonData)")
          let payload: [String: Any] = [
            "STATUS": "SUCCESS",
            "DATA": jsonData
          ]
          result(payload)
        }
        return
      case .failure(let code, _, _, let error):
        var errorInfo: [String : Any] = [:]
        errorInfo["collect_error_code"] = code

        if let message = error?.localizedDescription {
          errorInfo["collect_error_message"] = message
        }
        switch code {
        case 400..<499:
          // Wrong request. This also can happend when your Routs not setup yet or your <vaultId> is wrong
          print("Error: Wrong Request, code: \(code)")
        case VGSErrorType.inputDataIsNotValid.rawValue:
          if let error = error as? VGSError {
            print("Error: Input data is not valid. Details:\n \(error)")
          }
        default:
          print("Error: Something went wrong. Code: \(code)")
        }
        print("Submit request error: \(code), \(String(describing: error))")

        let payload: [String: Any]  = [
          "STATUS": "FAILED",
        ]
        result(payload)
        return
      }
    }
  }
}
