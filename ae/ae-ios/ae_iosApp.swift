//
//  ae_iosApp.swift
//  ae-ios
//
//  Created by blaine on 4/13/22.
//

import SwiftUI
import FlexiBLE

@main
struct ae_iosApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    private var flexiBLE: FlexiBLE
    
    init() {
        flexiBLE = FlexiBLE()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
                .environmentObject(flexiBLE)
        }
    }
}
