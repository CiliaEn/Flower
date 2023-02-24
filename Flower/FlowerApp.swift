//
//  FlowerApp.swift
//  Flower
//
//  Created by Cilia Ence on 2023-01-25.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import GoogleMaps


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      GMSServices.provideAPIKey("AIzaSyB9fsthnc9EVaJgsoG9ZjqO4q7f_KzoIbo")

    return true
  }
}

@main
struct FlowerApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


  var body: some Scene {
    WindowGroup {
        
      NavigationView {
        SplashScreenView()
      }
    }
  }
}
