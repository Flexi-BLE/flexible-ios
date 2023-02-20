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
    
    @Published var bleIsPoweredOn: Bool = fxb.conn.centralState == .poweredOn
    @Published var connectionLoading: Bool = false
    @Published var isEnabled: Bool = false
    @Published var shouldAutoConnect: Bool = false
    
    static let userDefaultsAutoConnectKey = "fxb-autoconnect"
    
    private var observers = Set<AnyCancellable>()
    
    private var timer: Timer? = nil
    
    init(with device: FXBDevice) {
        self.device = device
        checkAutoConnect()
        setupPubs()
    }
    
    func connect() {
        fxb.conn.enable(device: device)
    }
    
    func disconnect() {
        fxb.conn.disable(device: device)
    }
    
    func setAutoConnect(to shouldAutoConnect: Bool) {
        guard self.device.connectionState == .connected else {
            return
        }
        
        let contained = fxb.profile?.autoConnectDeviceNames.contains(self.device.deviceName) ?? false
        
        if shouldAutoConnect, !contained {
            fxb.profile?.autoConnectDeviceNames.append(self.device.deviceName)
        } else if !shouldAutoConnect, contained {
            fxb.profile?.autoConnectDeviceNames.removeAll(where: { $0 == self.device.deviceName })
        }
        
        fxb.conn.registerAutoConnect(devices: fxb.profile?.autoConnectDeviceNames ?? [])
    }
    
    private func setupPubs() {
        fxb.conn.$centralState
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
        guard let autoConnects = fxb.profile?.autoConnectDeviceNames else {
            return
        }
        
        let contained = autoConnects.contains(self.device.deviceName)
        if !self.shouldAutoConnect, contained { self.shouldAutoConnect = true }
        if self.shouldAutoConnect, !contained { self.shouldAutoConnect = false }
    }
}
