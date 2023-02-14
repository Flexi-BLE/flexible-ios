//
//  InfluxDBConnectionModel.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 1/4/23.
//

import Foundation
import Combine
import FlexiBLE
import UIKit


final class InfluxDBConnection: ObservableObject {
    
    var profile: FlexiBLEProfile?
    
    init() {
        if continousUploadInterval == 0 {
            self.continousUploadInterval = 30
        }
        
        if batchSize == 0 {
            self.batchSize = 1000
        }
        
        updateLiveUpload()
    }
    
    func set(profile: FlexiBLEProfile) {
        self.profile = profile
    }
    
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
    
    var liveUploader: LiveUploader?
    
    var validated: Bool {
        return !deviceId.isEmpty &&
            url != nil &&
            port > 0 &&
            !org.isEmpty &&
            !bucket.isEmpty &&
            !token.isEmpty &&
            batchSize > 0
    }
    
    var deviceId: String = UserDefaults.standard.string(forKey: UserDefaultsKey.deviceId.rawValue) ?? UIDevice.current.id {
        didSet {
            UserDefaults.standard.set(deviceId, forKey: UserDefaultsKey.deviceId.rawValue)
            updateLiveUpload()
        }
    }
    
    var urlString: String = UserDefaults.standard.string(forKey: UserDefaultsKey.url.rawValue) ?? "" {
        didSet {
            UserDefaults.standard.set(urlString, forKey: UserDefaultsKey.url.rawValue)
            updateLiveUpload()
        }
    }
    
    var port: Int = UserDefaults.standard.integer(forKey: UserDefaultsKey.port.rawValue) {
        didSet {
            UserDefaults.standard.set(port, forKey: UserDefaultsKey.port.rawValue)
            updateLiveUpload()
        }
    }
    
    var org: String = UserDefaults.standard.string(forKey: UserDefaultsKey.org.rawValue) ?? "" {
        didSet {
            UserDefaults.standard.set(org, forKey: UserDefaultsKey.org.rawValue)
            updateLiveUpload()
        }
    }
    
    var bucket: String = UserDefaults.standard.string(forKey: UserDefaultsKey.bucket.rawValue) ?? "" {
        didSet {
            UserDefaults.standard.set(bucket, forKey: UserDefaultsKey.bucket.rawValue)
            updateLiveUpload()
        }
    }
    
    var token: String = UserDefaults.standard.string(forKey: UserDefaultsKey.token.rawValue) ?? "" {
        didSet {
            UserDefaults.standard.set(token, forKey: UserDefaultsKey.token.rawValue)
            updateLiveUpload()
        }
    }
    
    var batchSize: Int = UserDefaults.standard.integer(forKey: UserDefaultsKey.batchSize.rawValue) {
        didSet {
            UserDefaults.standard.set(batchSize, forKey: UserDefaultsKey.batchSize.rawValue)
            updateLiveUpload()
        }
    }
    
    var continousUploadEnabled: Bool = UserDefaults.standard.bool(forKey: UserDefaultsKey.continousUploadEnabled.rawValue) {
        didSet {
            UserDefaults.standard.set(continousUploadEnabled, forKey: UserDefaultsKey.continousUploadEnabled.rawValue)
            updateLiveUpload()
        }
    }
    
    var continousUploadInterval: Int = UserDefaults.standard.integer(forKey: UserDefaultsKey.continousUploadInterval.rawValue) {
        didSet {
            UserDefaults.standard.set(continousUploadInterval, forKey: UserDefaultsKey.continousUploadInterval.rawValue)
            updateLiveUpload()
        }
    }
    
    var purgeOnUpload: Bool = UserDefaults.standard.bool(forKey: UserDefaultsKey.purgeOnUpload.rawValue) {
        didSet {
            UserDefaults.standard.set(purgeOnUpload, forKey: UserDefaultsKey.purgeOnUpload.rawValue)
            updateLiveUpload()
        }
    }
    
    var url: URL? {
        guard !urlString.isEmpty, port > 0 else { return nil }
        return URL(string: "\(urlString):\(port)/api/v2/write")
    }
    
    func start() {
        updateLiveUpload()
    }
    
    func uploader(start: Date?, end: Date=Date.now) -> InfluxDBUploader? {
        guard let profile = profile else {
            return nil
        }
        
        if validated {
            let creds = InfluxDBCredentials(
                url: url!,
                org: org,
                bucket: bucket,
                token: token,
                batchSize: batchSize,
                deviceId: deviceId,
                purgeOnUpload: purgeOnUpload,
                uploadInterval: Double(continousUploadInterval)
            )
            return InfluxDBUploader(
                profile: profile,
                credentials: creds,
                startDate: start,
                endDate: end
            )
        }
        
        return nil
    }
    
    func updateLiveUpload() {
        guard let profile = profile,
              continousUploadEnabled else {
            
                  liveUploader?.stop()
            liveUploader = nil
            return
        }
        
        guard validated else {
            continousUploadEnabled = false
            return
        }
        
        liveUploader = LiveUploader(model: self, profile: profile)
    }
}
