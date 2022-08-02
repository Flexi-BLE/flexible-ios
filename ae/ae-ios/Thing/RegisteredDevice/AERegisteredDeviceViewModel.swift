//
//  AERegisteredDeviceViewModel.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/1/22.
//

import Foundation
import Combine
import SwiftUI
import aeble

@MainActor class AERegisteredDeviceViewModel: ObservableObject {
    let metadata: AEBLERegisteredDevice
    
    @Published var connectionStatus: String = AEBLEPeripheralState.disconnected.humanReadable
    
    private var enabled: Bool = true
    @Published var isEnabled: Binding<Bool>?
    
    private var connectionStatusCancellable: AnyCancellable?
    private var bleStatusCancellable: AnyCancellable?
    
    private var peripheral: AEBLERegisteredPeripheral? {
        didSet {
            connectionStatusCancellable = peripheral?.$state.sink(receiveValue: { self.connectionStatus = $0.humanReadable
            })
        }
    }
    
    init(with metdata: AEBLERegisteredDevice) {
        self.metadata = metdata
        
        isEnabled = Binding<Bool>(
            get: { self.enabled },
            set: { newVal in
                self.enabled = newVal
                self.didUpdateEnabled(newVal)
            }
        )
        
        bleStatusCancellable = aeble.conn.$centralState.sink(receiveValue: { cbstate in
            switch cbstate {
            case .poweredOn:
                self.peripheral = aeble.conn.registeredPeripheral(for: self.metadata.name)
            default: break
            }
        })
        
        self.peripheral = aeble.conn.registeredPeripheral(for: metadata.name)
    }
    
    private func didUpdateEnabled(_ isEnabled: Bool) {
        self.enabled = isEnabled
        if isEnabled {
            aeble.conn.enable(registeredDevice: metadata)
        } else {
            aeble.conn.disable(registeredDevice: metadata)
        }
    }
    
}
