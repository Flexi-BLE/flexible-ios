//
//  RegisteredDeviceViewModel.swift
//  Flexi-BLE
//
//  Created by blaine on 9/26/22.
//

import Foundation
import Combine
import FlexiBLE

@MainActor class RegisteredDeviceViewModel: ObservableObject {
    var device: FXBRegisteredDevice
    
    @Published var bleIsPoweredOn: Bool = fxb.conn.centralState == .poweredOn
    @Published var connectionLoading: Bool = false
    @Published var isEnabled: Bool = false
    
    private var observers = Set<AnyCancellable>()
    
    init(with device: FXBRegisteredDevice) {
        self.device = device
        setupPubs()
    }
    
    func connect() {
        fxb.conn.enable(device: self.device)
    }
    
    func disconnect() {
        fxb.conn.disable(device: self.device)
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
                case .disconnected:
                    self?.connectionLoading = false
                    self?.isEnabled = false
                case .connecting, .initializing:
                    self?.connectionLoading = true
                }
            })
            .store(in: &observers)
        
        self.$isEnabled
            .sink{ [weak self] enabled in
                if self?.device.connectionState == .disconnected, enabled {
                    self?.connect()
                } else if self?.device.connectionState == .connected, !enabled {
                    self?.disconnect()
                }
            }.store(in: &observers)
    }
}
