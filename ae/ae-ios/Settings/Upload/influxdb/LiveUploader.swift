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
    private var timer: Publishers.Autoconnect<Timer.TimerPublisher>?
    private var timerCancellable: AnyCancellable?
    
    private let logger = Logger(subsystem: "com.blainerothrock.flexible", category: "live-uploader")
    
    private var credentials: InfluxDBCredentials
    private var uploadTask: Task<Bool, Error>?
    
    init(model: InfluxDBConnection) {
        self.credentials = InfluxDBCredentials(
            url: model.url!,
            org: model.org,
            bucket: model.bucket,
            token: model.token,
            batchSize: model.batchSize,
            deviceId: model.deviceId,
            purgeOnUpload: model.purgeOnUpload,
            uploadInterval: Double(model.continousUploadInterval)
        )
        self.start()
    }
    
    func start() {
        timerCancellable?.cancel()
        timerCancellable = nil
        
        guard let uploadInterval = credentials.uploadInterval else {
            return
        }
        
        timer = Timer.publish(
            every: uploadInterval,
            on: .current,
            in: .default
        ).autoconnect()
        
        timerCancellable = timer?
            .receive(on: DispatchQueue.global(qos: .background))
            .sink(receiveValue: { [weak self] _ in
                self?.upload()
            })
        
        logger.info("uploader started")
    }
    
    func stop() {
        timerCancellable?.cancel()
        timerCancellable = nil
        
        timer = nil
        logger.info("uploader stopped")
    }
    
    func upload() {
        if let task = self.uploadTask {
            task.cancel()
            uploadTask = nil
        }
        
        self.uploadTask = Task(priority: .medium) { () -> Bool in
            
            logger.info("starting scheduled upload")
            
            let uploader = InfluxDBUploader(
                credentials: credentials,
                startDate: nil,
                endDate: Date.now
            )
            
            let res = await uploader.upload()
            switch res {
            case .success(_): return true
            case .failure(let error): throw error
            }
        }
    }
}
