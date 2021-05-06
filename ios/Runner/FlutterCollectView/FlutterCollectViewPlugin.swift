//
//  FlutterCollectViewPlugin.swift
//  Runner
//

import Foundation
import Flutter

/// Flutter plugin for bridging VGSCollect.
public class FlutterCollectViewPlugin {
 class func register(with registrar: FlutterPluginRegistrar) {
	 let viewFactory = FlutterCollectViewFactory(messenger: registrar.messenger())
	 registrar.register(viewFactory, withId: "card-collect-form-view")
 }
}
