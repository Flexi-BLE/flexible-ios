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
    let device: FXBRegisteredDevice
    
//    @Published var connectionStatus: String = FXBPeripheralState.disconnected.humanReadable
    
    private var enabled: Bool = true
    @Published var isEnabled: Binding<Bool>?
    
    private var connectionStatusCancellable: AnyCancellable?
    private var bleStatusCancellable: AnyCancellable?
    
    init(with device: FXBRegisteredDevice) {
        self.device = device
        
        isEnabled = Binding<Bool>(
            get: { self.enabled },
            set: { newVal in
                self.enabled = newVal
                self.didUpdateEnabled(newVal)
            }
        )
        
//        bleStatusCancellable = fxb.conn.$centralState.sink(receiveValue: { cbstate in
//            switch cbstate {
//            case .poweredOn:
//                self.peripheral = fxb.conn.registeredPeripheral(for: self.device.spec.name)
//            default: break
//            }
//        })
        
//        self.peripheral = fxb.conn.registeredPeripheral(for: device.spec.name)
    }
    
    private func didUpdateEnabled(_ isEnabled: Bool) {
        self.enabled = isEnabled
        if isEnabled {
            fxb.conn.enable(device: device)
        } else {
            fxb.conn.disable(device: device)
        }
    }
    
}
