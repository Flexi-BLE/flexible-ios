//
//  LiveUploader.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 12/16/22.
//

import Foundation
import Combine
import UIKit
import os
import FlexiBLE

class LiveUploader {
    private var uploader: InfluxDBUploader?
    
    private var timer: Publishers.Autoconnect<Timer.TimerPublisher>?
    private var timerCancellable: AnyCancellable?
    
    private let logger = Logger(subsystem: "com.blainerothrock.flexible", category: "live-uploader")
    
    private var userDefaults = UserDefaults.standard
    var url: String? {
        return userDefaults
            .string(
                forKey: UploadDataInfluxDBViewModel
                    .UserDefaultsKey
                    .url
                    .rawValue
            )
    }
    
    var port: String? {
        return userDefaults
            .string(
                forKey: UploadDataInfluxDBViewModel
                    .UserDefaultsKey
                    .port
                    .rawValue
            )
    }
    
    var org: String? {
        return userDefaults
            .string(
                forKey: UploadDataInfluxDBViewModel
                    .UserDefaultsKey
                    .org
                    .rawValue
            )
    }
    
    var bucket: String? {
        return userDefaults
            .string(
                forKey: UploadDataInfluxDBViewModel
                    .UserDefaultsKey
                    .bucket
                    .rawValue
            )
    }
    
    var token: String? {
        return userDefaults
            .string(
                forKey: UploadDataInfluxDBViewModel
                    .UserDefaultsKey
                    .token
                    .rawValue
            )
    }
    
    var deviceId: String? {
        return userDefaults
            .string(forKey: UploadDataViewModel.UserDefaultsKey.deviceId.rawValue) ?? UIDevice.current.id
    }
    
    init() {
        setupUploader()
    }
    
    func start() {
        timer = Timer.publish(
            every: 30.0,
            on: .current,
            in: .default
        ).autoconnect()
        
        timerCancellable = timer?
            .receive(on: DispatchQueue.global(qos: .background))
            .sink(receiveValue: { [weak self] _ in self?.upload() })
        
        logger.info("uploader started")
    }
    
    func stop() {
        timer = nil
        uploader = nil
        logger.info("uploader stopped")
    }
    
    func setupUploader() {
        guard let urlString = url,
              let port = port,
              let url = URL(string: "\(urlString):\(port)/api/v2/write"),
              let org = org,
              let bucket = bucket,
              let token = token,
              let deviceId = deviceId else { return }
                
        self.uploader = InfluxDBUploader(
            url: url,
            org: org,
            bucket: bucket,
            token: token,
            deviceId: deviceId
        )
        
        logger.info("uploader initialized")
    }
    
    func upload() {
        guard let uploader = uploader else {
            setupUploader()
            return
        }
        
        logger.info("uploading: \(uploader.state.stringValue) - \(uploader.statusMessage )")
        uploader.start()
    }
}
