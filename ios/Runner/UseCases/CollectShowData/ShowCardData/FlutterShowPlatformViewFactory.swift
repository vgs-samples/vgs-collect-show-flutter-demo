//
//  FlutterShowViewFactory.swift
//  Runner

import Foundation
import Flutter
import UIKit
import VGSCollectSDK

/// Flutter platform view factory.
class FlutterShowPlatformViewFactory: NSObject, FlutterPlatformViewFactory {

  // MARK: - Private vars

  /// Flutter binary messenger.
  private var messenger: FlutterBinaryMessenger

  // MARK: - Initialization

  /// Initializer.
  /// - Parameter messenger: `FlutterBinaryMessenger` object, Flutter binary messenger.
  init(messenger: FlutterBinaryMessenger) {
    self.messenger = messenger
  }

  // MARK: - FlutterPlatformViewFactory

  // no:doc
  public func create(withFrame frame: CGRect,
                     viewIdentifier viewId: Int64,
                     arguments args: Any?) -> FlutterPlatformView {
    return FlutterShowCardView(messenger: messenger,
                              frame: frame, viewId: viewId,
                              args: args)
  }

  // no:doc
  public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    return FlutterStandardMessageCodec.sharedInstance()
  }
}
