//
//  FlutterCustomCardDataCollectViewPlugin.swift
//  Runner


import Foundation
import Flutter

/// Flutter plugin for bridging VGSCollect.
public class FlutterCustomCardDataCollectViewPlugin {

  /// View factory.
  static var viewFactory: FlutterCustomCardDataCollectViewFactory?

  /// Registers Flutter plugin.
  /// - Parameter registrar: `FlutterPluginRegistrar` object, Flutter plugin registrar.
  class func register(with registrar: FlutterPluginRegistrar) {
    viewFactory = FlutterCustomCardDataCollectViewFactory(messenger: registrar.messenger())

    registrar.register(viewFactory!, withId: "card-collect-form-view")
  }
}
