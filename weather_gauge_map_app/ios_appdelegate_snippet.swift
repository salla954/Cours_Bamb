// À FUSIONNER dans ios/Runner/AppDelegate.swift

import UIKit
import Flutter
import GoogleMaps // <-- ajouter cet import

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("VOTRE_CLE_API_GOOGLE_MAPS") // <-- ajouter cette ligne
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

