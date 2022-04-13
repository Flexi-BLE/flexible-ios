//
//  AEBLESettingsViewModel.swift
//  ntrain-exthub (iOS)
//
//  Created by blaine on 3/9/22.
//

import SwiftUI
import Combine
import aeble

@MainActor class AEBLESettingsViewModel: ObservableObject {
    @Published var deviceId = ""
    @Published var userId = ""
    @Published var apiURL = ""
    @Published var uploadBatch = 0
    @Published var peripheralConfigId = ""
    @Published var isRemoteServerEnabled = false
    @Published var isLocalPeripheralConfig = false
    
    @Published var peripheralConfigNames: [String] = []
    @Published var bucketNames: [String] = []
    
    @Published var validationError: String? = nil
    
    
    init() {
        loadFromAEBLE()
    }
    
    func loadFromAEBLE() {
        deviceId = aeble.settings.deviceId
        userId = aeble.settings.userId
        apiURL = aeble.settings.apiURL.absoluteString
        uploadBatch = aeble.settings.uploadBatch
        peripheralConfigId = aeble.settings.peripheralConfigurationType.id
        isRemoteServerEnabled = aeble.settings.useRemoteServer
        isLocalPeripheralConfig = aeble.settings.peripheralConfigurationType == .localDefault
        
        peripheralConfigNames = [aeble.settings.peripheralConfigurationType.id]
        bucketNames = [aeble.settings.sensorDataBucketName]
        
        Task {
            await refreshConfigNames()
            await refreshBucketNames()
        }
    }
    
    func refreshConfigNames() async {
        peripheralConfigNames = await aeble.settings.avaiablePeripheralConfiguration()
            .sorted(by: { f, s in
                return f == aeble.settings.peripheralConfigurationType.id
            })
    }
    
    func refreshBucketNames() async {
        bucketNames = await aeble.settings.buckets()
            .sorted(by: { f, s in
                return f == aeble.settings.sensorDataBucketName
            })
    }
    
    func save(configIndex: Int, bucketNameIndex: Int) {
        aeble.settings.deviceId = deviceId
        aeble.settings.userId = userId
        
        guard let url = URL(string: apiURL) else {
            validationError = "API URL must be a valid URL"
            return
        }
        
        if isRemoteServerEnabled {
            aeble.settings.sensorDataBucketName =  bucketNames[bucketNameIndex]
        }
        
        aeble.settings.apiURL = url
        aeble.settings.uploadBatch = uploadBatch
        
        
        if isLocalPeripheralConfig {
            aeble.settings.peripheralConfigurationType = .localDefault
        } else {
            aeble.settings.peripheralConfigurationType = AEBLESettingsStore
                .PeripheralConfigType
                .fromId(peripheralConfigNames[configIndex])
        }
        
    }
}
