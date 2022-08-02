//
//  AEThingViewModel.swift
//  ae
//
//  Created by blaine on 4/26/22.
//

import Foundation
import Combine
import SwiftUI
import aeble

extension AEBLEPeripheralState {
    var humanReadable: String {
        switch self {
        case .connected: return "Connected"
        case .disconnected: return "Disconnected"
        case .notFound: return "Not Found"
        }
    }
}

@MainActor class AEThingViewModel: ObservableObject {
    let thing: AEThing
    
    @Published var connectionStatus: String = AEBLEPeripheralState.disconnected.humanReadable
    @Published var lastWrite: Date? = nil
    
    private var enabled: Bool=true
    @Published var isEnabled: Binding<Bool>?
    
    private var connectionStatusCancellable: AnyCancellable?
    private var bleStatusCancellable: AnyCancellable?
    
    private var timer: Timer? = nil
    
    private var peripheral: AEBLEPeripheral? {
        didSet {
            connectionStatusCancellable = peripheral?.$state.sink(receiveValue: {
                self.connectionStatus = $0.humanReadable
            })
        }
    }
    
    init(with thing: AEThing) {
        self.thing = thing
        
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
                self.peripheral = aeble.conn.peripheral(for: thing.name)
            default: break
            }
        })
        
        timer = Timer.scheduledTimer(
            withTimeInterval: 0.25,
            repeats: true,
            block: { _ in
                Task {
                    self.lastWrite = await aeble.db.lastDataStreamDate(for: thing)
                }
            }
        )
        
        self.peripheral = aeble.conn.peripheral(for: thing.name)
    }
    
    private func didUpdateEnabled(_ isEnabled: Bool) {
        self.enabled = isEnabled
        if isEnabled {
            aeble.conn.enable(thing: thing)
        } else {
            aeble.conn.disable(thing: thing)
        }
    }
}
