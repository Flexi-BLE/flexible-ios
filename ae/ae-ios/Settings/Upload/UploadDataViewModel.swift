//
//  UploadDataViewModel.swift
//  Flexi-BLE
//
//  Created by blaine on 9/1/22.
//

import Foundation
import UIKit
import FlexiBLE

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
    
    let influxdbVM = UploadDataInfluxDBViewModel()
    var influxDBUploader: InfluxDBUploader?
    let questdbVM = UploadDataQuestDBViewModel()
    
    
    @Published var showUploading: Bool = false
    
    
    init() { }
    
    func save() {
        switch target {
        case .influxDB:
            if influxdbVM.isReady {
                influxDBUploader = InfluxDBUploader(
                    url: URL(string: "\(influxdbVM.url):\(influxdbVM.port)/api/v2/write")!,
                    org: influxdbVM.org,
                    bucket: influxdbVM.bucket,
                    token: influxdbVM.token,
                    startDate: nil,
                    endDate: Date.now,
                    batchSize: 1000,
                    deviceId: deviceId
                )
                showUploading = true
                influxDBUploader!.start()
            }
        case .questDB:
            print()
        }
    }
    
    func upload() {
        
    }
    
    
}
