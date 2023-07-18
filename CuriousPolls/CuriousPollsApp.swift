//
//  CuriousPollsApp.swift
//  CuriousPolls
//
//  Created by Rosa Jeon on 2023-07-18.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        let settings = Firestore.firestore().settings
//        comment next three lines to connect to real server and not local emulator
        settings.host = "127.0.0.1:8080"
        settings.cacheSettings = MemoryCacheSettings()
        settings.isSSLEnabled = false
        
        Firestore.firestore().settings = settings
        return true
    }
}

@main
struct CuriousPollsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
