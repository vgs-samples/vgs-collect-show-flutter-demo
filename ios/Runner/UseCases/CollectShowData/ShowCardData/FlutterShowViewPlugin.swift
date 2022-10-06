//
//  FlutterShowViewPlugin.swift
//  Runner

import Foundation
import Flutter

/// Flutter plugin for bridging VGSShow.
public class FlutterShowViewPlugin {

  /// View factory.
  static var viewFactory: FlutterShowPlatformViewFactory?

  /// Registers Flutter plugin.
  /// - Parameter registrar: `FlutterPluginRegistrar` object, Flutter plugin registrar.
  class func register(with registrar: FlutterPluginRegistrar) {
    viewFactory = FlutterShowPlatformViewFactory(messenger: registrar.messenger())

    registrar.register(viewFactory!, withId: "show-card-form-view")
  }
}
