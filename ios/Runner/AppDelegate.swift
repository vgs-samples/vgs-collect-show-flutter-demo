import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
		override func application(
				_ application: UIApplication,
				didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?
		) -> Bool {

				GeneratedPluginRegistrant.register(with: self)
		  	FlutterShowViewPlugin.register(with: registrar(forPlugin: "FlutterShowPlugin")!)
			  FlutterCollectViewPlugin.register(with: registrar(forPlugin: "FlutterCollectPlugin")!)
				return super.application(application, didFinishLaunchingWithOptions: launchOptions)
		}
}
