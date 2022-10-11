//
//  DataViewModel.swift
//  Flexi-BLE
//
//  Created by Blaine Rothrock on 9/22/22.
//

import Foundation
import Combine
import FlexiBLE

@MainActor class DeviceDataViewModel: ObservableObject {
    @Published var deviceConnectionRecords: [FXBConnection] = []
    
    @Published var selectedDeviceId: Int = -1 {
        didSet {
            deviceSpec = nil
            connectedDevice = nil
            if selectedDeviceId > -1 {
                if deviceConnectionRecords.count > selectedDeviceId {
                    getSpec(with: deviceConnectionRecords[selectedDeviceId])
                } else {
                    selectedDeviceId = -1
                }
            }
        }
    }
    
    @Published var deviceSpec: FXBDeviceSpec?
    @Published var connectedDevice: FXBDevice?
    
    private var observers = Set<AnyCancellable>()
    
    var deviceName: String {
        if selectedDeviceId == -1 {
            return "--none--"
        } else {
            return deviceConnectionRecords[selectedDeviceId].deviceName
        }
    }
    
    init() {
        fetchConnectionRecords()
        
        fxb.conn.fxbConnectedDevices.publisher.sink { _ in
            gLog.debug("Connected Device Did Change.")
            self.fetchConnectionRecords()
        }.store(in: &observers)
    }
    
    func fetchConnectionRecords() {
        Task {
            let records = await fxb.read.connectionRecords()
            deviceConnectionRecords = []
            var deviceNamePairs: [String] = []
            for rec in records {
                let recId = "\(rec.deviceType):\(rec.deviceName)"
                if !deviceNamePairs.contains(recId) {
                    self.deviceConnectionRecords.append(rec)
                    deviceNamePairs.append(recId)
                }
            }
            
            if self.selectedDeviceId == -1, self.deviceConnectionRecords.count > 0 {
                self.selectedDeviceId = 0
            } else if self.selectedDeviceId > -1, self.deviceConnectionRecords.count < self.selectedDeviceId+1 {
                self.selectedDeviceId = self.deviceConnectionRecords.count > -1 ? 0 : -1
            } else if selectedDeviceId > -1 {
                getSpec(with: deviceConnectionRecords[selectedDeviceId])
            }
        }
    }
    
    func getSpec(with connection: FXBConnection) {
        Task {
            if let spec = await fxb.read.spec(by: connection.specId) {
                self.deviceSpec = spec.devices.first(where: { $0.name == connection.deviceType })
                if let device = fxb.conn.fxbConnectedDevices.first(where: { $0.deviceName == deviceName }) {
                    self.connectedDevice = device
                    self.connectedDevice?.$connectionState
                        .sink(receiveValue: { state in
                            switch state {
                            case .disconnected:
                                self.connectedDevice = nil
                                self.deviceSpec = nil
                                self.fetchConnectionRecords()
                            default: break
                            }
                        })
                        .store(in: &observers)
                }
            }
        }
    }
    
    func reloadAllDefaults() {
        guard let spec = self.deviceSpec, let device = self.connectedDevice else { return }
        spec.dataStreams.forEach { ds in
            fxb.conn.updateConfig(deviceName: device.deviceName, dataStream: ds)
            self.deviceSpec = nil
            self.connectedDevice = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: { [weak self] in
                self?.fetchConnectionRecords()
            })
        }
    }
}
