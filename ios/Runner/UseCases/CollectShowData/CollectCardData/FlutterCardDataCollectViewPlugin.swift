//
//  FlutterCardDataCollectViewPlugin.swift
//  Runner
//

import Foundation
import Flutter

/// Flutter plugin for bridging VGSCollect.
public class FlutterCardDataCollectViewPlugin {

  /// View factory.
  static var viewFactory: FlutterCardDataCollectViewFactory?

  /// Registers Flutter plugin.
  /// - Parameter registrar: `FlutterPluginRegistrar` object, Flutter plugin registrar.
  class func register(with registrar: FlutterPluginRegistrar) {
    viewFactory = FlutterCardDataCollectViewFactory(messenger: registrar.messenger())

    registrar.register(viewFactory!, withId: "card-collect-for-show-form-view")
  }
}
