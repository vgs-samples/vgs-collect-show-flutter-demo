//
//  FlutterShowCardView.swift
//  Runner
//

import Foundation
import Flutter
import UIKit
import VGSCollectSDK
import VGSShowSDK

/// FlutterPlatformView wrapper for Show view.
class FlutterShowCardView: NSObject, FlutterPlatformView {

  // MARK: - Vars

  /// VGS Show instance.
  var vgsShow: VGSShow?

  /// Show view.
  let showCardView: ShowCardView

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
    self.showCardView = ShowCardView()

    // Create flutter method channel.
    self.channel = FlutterMethodChannel(name: "show-card-form-view/\(viewId)",
                                       binaryMessenger: messenger)


    super.init()

    // Handle methods from Flutter.
    channel.setMethodCallHandler({[weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      switch call.method {
      case "configureShow":
        self?.configShow(with: call.arguments)
        result(nil)
      case "copyCard":
        self?.showCardView.cardNumberVGSLabel.copyTextToClipboard()
        result(nil)
      case "revealCard":
        self?.revealCard(with: call.arguments, result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    })
  }

  // MARK: - Event channel

  // MARK: - FlutterPlatformView

  // no:doc
  public func view() -> UIView {
   return showCardView
  }

  // MARK: - Helpers

  /// Configure VGS Show.
  /// - Parameter args: `Any?` object, method arguments.
  private func configShow(with args: Any?) {
    guard let payload = args as? [String: Any],
          let vaultID = payload["vault_id"] as? String,
       let environment = payload["environment"] as? String else {
      assertionFailure("Invalid config")
      return
    }

    let vgsShow = VGSShow(id: vaultID, environment: environment)
    self.showCardView.subscribeViewsToShow(vgsShow)
    self.vgsShow = vgsShow
  }

  /// Redact card with Flutter result completion block object.
  /// - Parameter result: `FlutterResult` object, Flutter result completion block object.
  private func revealCard(with args: Any?, result: @escaping FlutterResult)  {
    guard let payload = args as? [String: Any],
          let path = payload["path"] as? String,
          let payloadToReveal = payload["payload"] as? [String: Any] else {
      assertionFailure("Invalid config")
      return
    }

    vgsShow?.request(path: path, payload: payloadToReveal,  completion: { requestResult in
      switch requestResult {
      case .success(let code):
        let payload: [String: Any]  = [
          "STATUS": "SUCCESS",
        ]
        result(payload)
      case .failure(let code, let error):
        let payload: [String: Any]  = [
          "STATUS": "FAILED",
          "CODE": code
        ]
        result(payload)
      }
    })
  }
}
