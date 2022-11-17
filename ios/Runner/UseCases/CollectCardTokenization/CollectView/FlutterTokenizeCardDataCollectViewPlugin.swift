//
//  FlutterTokenizeCardDataCollectViewPlugin.swift
//  Runner

import Foundation
import Flutter

/// Flutter plugin for bridging VGSCollect.
public class FlutterTokenizeCardDataCollectViewPlugin {

  /// View factory.
  static var viewFactory: FlutterTokenizeCardDataCollectViewFactory?

  /// Registers Flutter plugin.
  /// - Parameter registrar: `FlutterPluginRegistrar` object, Flutter plugin registrar.
  class func register(with registrar: FlutterPluginRegistrar) {
    viewFactory = FlutterTokenizeCardDataCollectViewFactory(messenger: registrar.messenger())

    registrar.register(viewFactory!, withId: "tokenize-card-collect-form-view")
  }
}
