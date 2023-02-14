//
//  AEThingViewModel.swift
//  ae
//
//  Created by blaine on 4/26/22.
//

import Foundation
import Combine
import SwiftUI
import FlexiBLE

@MainActor class FXBDeviceViewModel: ObservableObject {
    var device: FXBDevice
    var profile: FlexiBLEProfile
    
    @Published var bleIsPoweredOn: Bool
    @Published var connectionLoading: Bool = false
    @Published var isEnabled: Bool = false
    @Published var shouldAutoConnect: Bool = false
    
    static let userDefaultsAutoConnectKey = "fxb-autoconnect"
    
    private var observers = Set<AnyCancellable>()
    
    private var timer: Timer? = nil
    
    init(profile: FlexiBLEProfile, device: FXBDevice) {
        self.device = device
        self.profile = profile
        self._bleIsPoweredOn = .init(initialValue: profile.conn.centralState == .poweredOn)
        
        checkAutoConnect()
        setupPubs()
    }
    
    func connect() {
        profile.conn.enable(device: device)
    }
    
    func disconnect() {
        profile.conn.disable(device: device)
    }
    
    func setAutoConnect(to shouldAutoConnect: Bool) {
        guard let autoConnects: [String] = try? UserDefaults
            .standard
            .getCustomObject(forKey: FXBDeviceViewModel.userDefaultsAutoConnectKey),
              self.device.connectionState == .connected else {
            
            return
        }
        
        let contained = autoConnects.contains(self.device.deviceName)
        var newAutoConnects = autoConnects.map({ $0 })
        
        if shouldAutoConnect, !contained {
            newAutoConnects.append(self.device.deviceName)
        } else if !shouldAutoConnect, contained {
            newAutoConnects.removeAll(where: { $0 == self.device.deviceName })
        }
        
        try? UserDefaults.standard.setCustomObject(
            newAutoConnects,
            forKey: FXBDeviceViewModel.userDefaultsAutoConnectKey
        )
        profile.conn.registerAutoConnect(devices: newAutoConnects)
    }
    
    private func setupPubs() {
        profile.conn.$centralState
            .sink { [weak self] state in
                switch state {
                case .poweredOn: self?.bleIsPoweredOn = true
                default: self?.bleIsPoweredOn = false
                }
            }
            .store(in: &observers)
        
        
        device.$connectionState
            .sink(receiveValue: { [weak self] state in
                UserInterfaceLogger.info("device connection state: \(state.rawValue)")
                switch state {
                case .connected:
                    self?.connectionLoading = false
                    self?.isEnabled = true
                    self?.checkAutoConnect()
                case .disconnected:
                    self?.connectionLoading = false
                    self?.isEnabled = false
                case .connecting, .initializing:
                    self?.connectionLoading = true
                }
            })
            .store(in: &observers)
        
        self.$isEnabled
            .sink { [weak self] enabled in
                if self?.device.connectionState == .disconnected, enabled {
                    self?.connect()
                } else if self?.device.connectionState == .connected, !enabled {
                    self?.disconnect()
                }
            }
            .store(in: &observers)
        
        self.$shouldAutoConnect
            .sink { [weak self] ac in self?.setAutoConnect(to: ac) }
            .store(in: &observers)
    }
    
    private func checkAutoConnect() {
        do {
            let autoConnects: [String] = try UserDefaults
                .standard
                .getCustomObject(forKey: FXBDeviceViewModel.userDefaultsAutoConnectKey)
                
            profile.conn.registerAutoConnect(devices: autoConnects)
            let contained = autoConnects.contains(self.device.deviceName)
            if !self.shouldAutoConnect, contained { self.shouldAutoConnect = true }
            if self.shouldAutoConnect, !contained { self.shouldAutoConnect = false }
        } catch {
            profile.conn.registerAutoConnect(devices: [])
            if self.shouldAutoConnect { self.shouldAutoConnect = false }
        }
    }
}
