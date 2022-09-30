//
//  UploadDataInfluxDBViewModel.swift
//  Flexi-BLE
//
//  Created by blaine on 9/1/22.
//

import Foundation

@MainActor class UploadDataInfluxDBViewModel: ObservableObject {
    
    enum UserDefaultsKey: String {
        case url = "fxb_influxdb_url"
        case port = "fxb_influxdb_port"
        case org = "fxb_influxdb_org"
        case bucket = "fxb_influxdb_bucket"
        case token = "fxb_influxdb_token"
        case batchSize = "fxb_influxdb_recordBatchSize"
        
    }
    
    @Published var isReady: Bool = false
    
    @Published var url: String = UserDefaults.standard.string(forKey: UserDefaultsKey.url.rawValue) ?? "" {
        didSet {
            UserDefaults.standard.set(url, forKey: UserDefaultsKey.url.rawValue)
            validate()
        }
    }
    
    @Published var port: String = UserDefaults.standard.string(forKey: UserDefaultsKey.port.rawValue) ?? "8086" {
        didSet {
            UserDefaults.standard.set(port, forKey: UserDefaultsKey.port.rawValue)
            validate()
        }
    }
    
    @Published var org: String = UserDefaults.standard.string(forKey: UserDefaultsKey.org.rawValue) ?? "" {
        didSet {
            UserDefaults.standard.set(org, forKey: UserDefaultsKey.org.rawValue)
            validate()
        }
    }
    
    @Published var bucket: String = UserDefaults.standard.string(forKey: UserDefaultsKey.bucket.rawValue) ?? "" {
        didSet {
            UserDefaults.standard.set(bucket, forKey: UserDefaultsKey.bucket.rawValue)
            validate()
        }
    }
    
    @Published var token: String = UserDefaults.standard.string(forKey: UserDefaultsKey.token.rawValue) ?? "" {
        didSet {
            UserDefaults.standard.set(token, forKey: UserDefaultsKey.token.rawValue)
            validate()
        }
    }
    
//    @Published var batchSize: String = UserDefaults.standard.string(forKey: UserDefaultKey.batchSize.rawValue) ?? "1000" {
//        didSet {
//            UserDefaults.standard.set(batchSize, forKey: UserDefaultKey.batchSize.rawValue)
//        }
//    }
    
    init() {
        self.validate()
    }
    
    func validate() {
        isReady = !url.isEmpty &&
            !port.isEmpty &&
            !org.isEmpty &&
            !bucket.isEmpty &&
            !token.isEmpty
    }
}

