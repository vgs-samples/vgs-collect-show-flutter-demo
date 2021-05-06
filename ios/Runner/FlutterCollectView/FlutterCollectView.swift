//
//  FlutterCollectView.swift
//  Runner
//

import Foundation
import Flutter
import UIKit
import VGSCollectSDK

/// FlutterPlatformView wrapper for Collect view.
class FlutterCollectView: NSObject, FlutterPlatformView {

  // MARK: - Vars

	let vgsCollect = VGSCollect(id: DemoAppConfig.shared.vaultId, environment: .sandbox)

	let collectView: CollectView
	let messenger: FlutterBinaryMessenger
	let channel: FlutterMethodChannel
	let viewId: Int64

	// MARK: - Initializer

	init(messenger: FlutterBinaryMessenger,
			 frame: CGRect,
			 viewId: Int64,
			 args: Any?) {
		self.messenger = messenger
		self.viewId = viewId
		self.collectView = CollectView()

		channel = FlutterMethodChannel(name: "card-collect-form-view/\(viewId)",
																			 binaryMessenger: messenger)

		super.init()
		self.collectView.configureFieldsWithCollect(vgsCollect)

		channel.setMethodCallHandler({ (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
			switch call.method {
			case "redactCard":
				self.redactCard(with: result)
			default:
				result(FlutterMethodNotImplemented)
			}
		})
	}

	// MARK: - FlutterPlatformView

	public func view() -> UIView {
	 return collectView
	}

	// MARK: - Helpers

	private func redactCard(with result: @escaping FlutterResult)  {
		vgsCollect.sendData(path: "/post", extraData: nil) { [weak self](response) in
			switch response {
			case .success(_, let data, _):
				if let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {

					print("SUCCESS: \(jsonData)")
					if let aliases = jsonData["json"] as? [String: Any],
						let cardNumber = aliases["cardNumber"],
						let expDate = aliases["expDate"] {

						let payload = ["cardNumber": cardNumber,
													 "expDate": expDate]
						result(payload)
					}
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

				result(errorInfo)
				return
			}
		}
	}
}
