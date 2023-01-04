//
//  UploadDataInfluxDBViewModel.swift
//  Flexi-BLE
//
//  Created by blaine on 9/1/22.
//

import Foundation
import UIKit
import FlexiBLE

@MainActor class UploadDataInfluxDBViewModel: ObservableObject {
    
    @Published var showUploading: Bool = false
    
    enum UserDefaultsKey: String {
        case url = "fxb_influxdb_url"
        case port = "fxb_influxdb_port"
        case org = "fxb_influxdb_org"
        case bucket = "fxb_influxdb_bucket"
        case token = "fxb_influxdb_token"
        case batchSize = "fxb_influxdb_recordBatchSize"
        case deviceId = "fxb_device_id"
        
        case continousUploadEnabled = "fxb_continous_upload_enabled"
        case continousUploadInterval = "fxb_continous_upload_interval"
        case purgeOnUpload = "fxb_continuous_upload_purge"
    }
    
    @Published var isReady: Bool = false
    var influxDBUploader: InfluxDBUploader?
    
    @Published var deviceId: String = UserDefaults.standard.string(forKey: UserDefaultsKey.deviceId.rawValue) ?? UIDevice.current.id {
        didSet {
            UserDefaults.standard.set(deviceId, forKey: UserDefaultsKey.deviceId.rawValue)
            validate()
            continuousUpload()
        }
    }
    
    @Published var url: String = UserDefaults.standard.string(forKey: UserDefaultsKey.url.rawValue) ?? "" {
        didSet {
            UserDefaults.standard.set(url, forKey: UserDefaultsKey.url.rawValue)
            validate()
            continuousUpload()
        }
    }
    
    @Published var port: String = UserDefaults.standard.string(forKey: UserDefaultsKey.port.rawValue) ?? "" {
        didSet {
            UserDefaults.standard.set(port, forKey: UserDefaultsKey.port.rawValue)
            validate()
            continuousUpload()
        }
    }
    
    @Published var org: String = UserDefaults.standard.string(forKey: UserDefaultsKey.org.rawValue) ?? "" {
        didSet {
            UserDefaults.standard.set(org, forKey: UserDefaultsKey.org.rawValue)
            validate()
            continuousUpload()
        }
    }
    
    @Published var bucket: String = UserDefaults.standard.string(forKey: UserDefaultsKey.bucket.rawValue) ?? "" {
        didSet {
            UserDefaults.standard.set(bucket, forKey: UserDefaultsKey.bucket.rawValue)
            validate()
            continuousUpload()
        }
    }
    
    @Published var token: String = UserDefaults.standard.string(forKey: UserDefaultsKey.token.rawValue) ?? "" {
        didSet {
            UserDefaults.standard.set(token, forKey: UserDefaultsKey.token.rawValue)
            validate()
            continuousUpload()
        }
    }
    
    @Published var batchSize: String = UserDefaults.standard.string(forKey: UserDefaultsKey.batchSize.rawValue) ?? "1000" {
        didSet {
            UserDefaults.standard.set(batchSize, forKey: UserDefaultsKey.batchSize.rawValue)
            validate()
            continuousUpload()
        }
    }
    
    @Published var continousUploadEnabled: Bool = UserDefaults.standard.bool(forKey: UserDefaultsKey.continousUploadEnabled.rawValue) {
        didSet {
            UserDefaults.standard.set(continousUploadEnabled, forKey: UserDefaultsKey.continousUploadEnabled.rawValue)
            validate()
            continuousUpload()
        }
    }
    
    @Published var continousUploadInterval: String = UserDefaults.standard.string(forKey: UserDefaultsKey.continousUploadInterval.rawValue) ?? "30" {
        didSet {
            UserDefaults.standard.set(continousUploadInterval, forKey: UserDefaultsKey.continousUploadInterval.rawValue)
            validate()
            continuousUpload()
        }
    }
    
    @Published var purgeOnUpload: Bool = UserDefaults.standard.bool(forKey: UserDefaultsKey.purgeOnUpload.rawValue) {
        didSet {
            UserDefaults.standard.set(purgeOnUpload, forKey: UserDefaultsKey.purgeOnUpload.rawValue)
            validate()
            continuousUpload()
        }
    }
    
    init() {
        self.validate()
    }
    
    func validate() {
        isReady = !deviceId.isEmpty &&
            !url.isEmpty && URL(string: url) != nil &&
            !port.isEmpty && Int(port) != nil &&
            !org.isEmpty &&
            !bucket.isEmpty &&
            !token.isEmpty &&
            !batchSize.isEmpty && Int(batchSize) != nil
    }
    
    func save() {
        if isReady {
            influxDBUploader = InfluxDBUploader(
                url: URL(string: "\(url):\(port)/api/v2/write")!,
                org: org,
                bucket: bucket,
                token: token,
                startDate: nil,
                endDate: Date.now,
                batchSize: 1000,
                deviceId: deviceId,
                purgeOnUpload: purgeOnUpload
            )
            showUploading = true
        }
    }
    
    func continuousUpload() {
        if self.isReady {
            if continousUploadEnabled {
                LiveUpload.set(true)
                LiveUpload.globalUploader.stop()
                LiveUpload.globalUploader.start()
            } else {
                LiveUpload.set(false)
                LiveUpload.globalUploader.stop()
            }
            
            if let batchSize = Int(batchSize) {
                if LiveUpload.globalUploader.batchSize != batchSize {
                    LiveUpload.globalUploader.set(batchSize: batchSize)
                }
            }
            
            if let interval = Int(continousUploadInterval) {
                if Int(LiveUpload.globalUploader.interval) != interval {
                    LiveUpload.globalUploader.set(interval: interval)
                }
            }
        }
    }
}

