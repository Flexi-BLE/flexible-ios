//
//  AERegisteredDeviceViewModel.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/1/22.
//

import Foundation
import Combine
import SwiftUI
import FlexiBLE

@MainActor class AERegisteredDeviceViewModel: ObservableObject {
    let metadata: FXBRegisteredDevice
    
    @Published var connectionStatus: String = FXBPeripheralState.disconnected.humanReadable
    
    private var enabled: Bool = true
    @Published var isEnabled: Binding<Bool>?
    
    private var connectionStatusCancellable: AnyCancellable?
    private var bleStatusCancellable: AnyCancellable?
    
    private var peripheral: FXBRegisteredPeripheral? {
        didSet {
            connectionStatusCancellable = peripheral?.$state.sink(receiveValue: { self.connectionStatus = $0.humanReadable
            })
        }
    }
    
    init(with metdata: FXBRegisteredDevice) {
        self.metadata = metdata
        
        isEnabled = Binding<Bool>(
            get: { self.enabled },
            set: { newVal in
                self.enabled = newVal
                self.didUpdateEnabled(newVal)
            }
        )
        
        bleStatusCancellable = fxb.conn.$centralState.sink(receiveValue: { cbstate in
            switch cbstate {
            case .poweredOn:
                self.peripheral = fxb.conn.registeredPeripheral(for: self.metadata.name)
            default: break
            }
        })
        
        self.peripheral = fxb.conn.registeredPeripheral(for: metadata.name)
    }
    
    private func didUpdateEnabled(_ isEnabled: Bool) {
        self.enabled = isEnabled
        if isEnabled {
            fxb.conn.enable(registeredDevice: metadata)
        } else {
            fxb.conn.disable(registeredDevice: metadata)
        }
    }
    
}
