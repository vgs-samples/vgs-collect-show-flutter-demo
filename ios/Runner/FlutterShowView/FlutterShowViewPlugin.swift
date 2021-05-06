//
//  FlutterShowViewPlugin.swift
//  Runner
//

import Foundation
import Flutter

/// Flutter plugin for bridging VGSShow.
public class FlutterShowViewPlugin {
 class func register(with registrar: FlutterPluginRegistrar) {
	 let viewFactory = FlutterShowViewFactory(messenger: registrar.messenger())
	 registrar.register(viewFactory, withId: "card-show-form-view")
 }
}
