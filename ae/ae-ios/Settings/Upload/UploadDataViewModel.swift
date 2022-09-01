//
//  UploadDataViewModel.swift
//  Flexi-BLE
//
//  Created by blaine on 9/1/22.
//

import Foundation
import UIKit

@MainActor class UploadDataViewModel: ObservableObject {
    enum Target: String, CaseIterable, Codable {
        case influxDB = "InfluxDB"
        case questDB = "QuestDB"
    }
    
    enum UserDefaultsKey: String {
        case dbTarget = "fxb_db_target"
        case deviceId = "fxb_device_id"
    }
    
    @Published var target: Target = Target(
        rawValue: UserDefaults
            .standard
            .string(forKey: UserDefaultsKey.dbTarget.rawValue) ?? Target.influxDB.rawValue)!
    {
        didSet {
            UserDefaults.standard.set(target.rawValue, forKey: UserDefaultsKey.dbTarget.rawValue)
        }
    }
    
    @Published var deviceId: String = UserDefaults.standard.string(forKey: UserDefaultsKey.deviceId.rawValue) ?? UIDevice.current.id {
        didSet {
            UserDefaults.standard.set(deviceId, forKey: UserDefaultsKey.deviceId.rawValue)
        }
    }
    
    
    init() { }
    
    
}
