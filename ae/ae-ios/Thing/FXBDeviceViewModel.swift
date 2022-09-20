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

extension FXBPeripheralState {
    var humanReadable: String {
        switch self {
        case .connected: return "Connected"
        case .disconnected: return "Disconnected"
        case .notFound: return "Not Found"
        }
    }
}

@MainActor class FXBDeviceViewModel: ObservableObject {
    @Published var thing: FXBDevice
    
    @Published var connectionStatus: FXBPeripheralState = .disconnected
    @Published var connectionStatusString: String = FXBPeripheralState.disconnected.humanReadable
    @Published var lastWrite: Date? = nil
    
    private var enabled: Bool=true
    @Published var isEnabled: Binding<Bool>?
    
    private var connectionStatusCancellable: AnyCancellable?
    private var bleStatusCancellable: AnyCancellable?
    
    private var timer: Timer? = nil
    
    private var peripheral: FXBPeripheral? {
        didSet {
            connectionStatusCancellable = peripheral?.$state.sink(receiveValue: {
                self.connectionStatusString = $0.humanReadable
                self.connectionStatus = $0
            })
        }
    }
    
    init(with thing: FXBDevice) {
        self.thing = thing
        
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
                self.peripheral = fxb.conn.peripheral(for: thing.name)
            default: break
            }
        })
        
        timer = Timer.scheduledTimer(
            withTimeInterval: 0.25,
            repeats: true,
            block: { _ in
                Task { [weak self] in
                    guard let self = self else { return }
//                    self.lastWrite = await fxb.db.lastDataStreamDate(for: thing)
                }
            }
        )
        
        self.peripheral = fxb.conn.peripheral(for: thing.name)
    }
    
    private func didUpdateEnabled(_ isEnabled: Bool) {
        self.enabled = isEnabled
        if isEnabled {
            fxb.conn.enable(thing: thing)
        } else {
            fxb.conn.disable(thing: thing)
        }
    }
}
