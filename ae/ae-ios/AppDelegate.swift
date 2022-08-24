//
//  AppDelegate.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 7/28/22.
//

import Foundation
import UIKit
import OSLog

internal let gLog = Logger(
    subsystem: "com.blainerothrock.ae-ios",
    category: "general"
)


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        gLog.info("application did finish launching")
        
        if let centralsIds = launchOptions?[.bluetoothCentrals] as? [String] {
            for id in centralsIds {
                gLog.debug("TODO: handle init of ble central \(id)")
            }
        } else {
            gLog.info("application did finish launching: no ble centrals")
        }
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        gLog.info("application is active")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        gLog.info("application will resign active")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        gLog.info("application will terminate")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        gLog.info("application did enter background")
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        gLog.info("application did recieve memory warning")
    }
    
}
