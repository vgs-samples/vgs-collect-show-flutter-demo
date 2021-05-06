//
//  FlutterShowViewFactory.swift
//  Runner
//

import Foundation
import Flutter
import UIKit

/// Flutter View factory for VGSShow wrapper.
class FlutterShowViewFactory: NSObject, FlutterPlatformViewFactory {

	// MARK: - Private vars

	private var messenger: FlutterBinaryMessenger

	// MARK: - Initialization

	init(messenger: FlutterBinaryMessenger) {
		self.messenger = messenger
	}

	// MARK: - Public

	public func create(withFrame frame: CGRect,
										 viewIdentifier viewId: Int64,
										 arguments args: Any?) -> FlutterPlatformView {
		return FlutterShowView(messenger: messenger,
															frame: frame, viewId: viewId,
															args: args)
	}
	public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
		return FlutterStandardMessageCodec.sharedInstance()
	}
}
