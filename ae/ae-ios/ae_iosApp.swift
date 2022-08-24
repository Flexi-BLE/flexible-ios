//
//  ae_iosApp.swift
//  ae-ios
//
//  Created by blaine on 4/13/22.
//

import SwiftUI

@main
struct ae_iosApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(.light)
        }
    }
}
