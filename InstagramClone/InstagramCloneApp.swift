//
//  InstagramCloneApp.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 05/09/23.
//
import SwiftUI
import FirebaseCore
import FirebaseStorage

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct InstagramCloneApp: App {
    var messageStore = MessageStore();
    var globalStore = GlobalStore()

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(globalStore)
                .environmentObject(messageStore)
        }
    }
}
