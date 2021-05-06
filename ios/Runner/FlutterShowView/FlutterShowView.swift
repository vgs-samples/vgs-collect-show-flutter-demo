//
//  FlutterShowView.swift
//  Runner
//

import Foundation
import Flutter
import UIKit
import VGSShowSDK

/// FlutterPlatformView wrapper for VGSShowView.
class FlutterShowView: NSObject, FlutterPlatformView {

	// MARK: - Vars

	let vgsShow = VGSShow(id: DemoAppConfig.shared.vaultId, environment: .sandbox)

	let showView: ShowView
	let messenger: FlutterBinaryMessenger
	let channel: FlutterMethodChannel
	let viewId: Int64

	// MARK: - Initialization

	init(messenger: FlutterBinaryMessenger,
			 frame: CGRect,
			 viewId: Int64,
			 args: Any?) {
		self.messenger = messenger
		self.viewId = viewId
		self.showView = ShowView()

		channel = FlutterMethodChannel(name: "card-show-form-view/\(viewId)",
																			 binaryMessenger: messenger)

		super.init()
		self.showView.subscribeViewsToShow(vgsShow)

		channel.setMethodCallHandler({ (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
			switch call.method {
			case "revealCard":
				self.revealCard(with: call, result: result)
			default:
					result(FlutterMethodNotImplemented)
			}
		})
	}

	// MARK: - FlutterPlatformView

	public func view() -> UIView {
	 return showView
	}

	// MARK: - Helpers

 	private func revealCard(with flutterMethodCall: FlutterMethodCall, result: @escaping FlutterResult)  {
		var errorInfo: [String : Any] = [:]
		var payload: [String : Any] = [:]
		guard let args = flutterMethodCall.arguments as? [Any],
					let cardToken = args.first as? String, let expDateToken = args[safe: 1] as? String
		else {
			errorInfo["show_error_code"] = 999
			errorInfo["show_error_message"] = "No payload to reveal. Collect some data first!"

			result(errorInfo)
			return
		}

		payload["payment_card_number"] = cardToken
		payload["payment_card_expiration_date"] = expDateToken

		vgsShow.request(path: DemoAppConfig.shared.path,
										method: .post, payload: payload) { (requestResult) in

			switch requestResult {
			case .success(let code):
				var successInfo: [String : Any] = [:]
				successInfo["show_status_code"] = code

				result(successInfo)
			case .failure(let code, let error):
				errorInfo["show_error_code"] = code
				if let message = error?.localizedDescription {
					errorInfo["show_error_message"] = message
				}

				result(errorInfo)
			}
		}
	}
}
