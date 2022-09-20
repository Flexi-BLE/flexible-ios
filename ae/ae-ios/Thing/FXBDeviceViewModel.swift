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
    let specVersion: String
    
    @Published var connectionStatus: FXBPeripheralState = .disconnected
    @Published var connectionStatusString: String = FXBPeripheralState.disconnected.humanReadable
    @Published var lastWrite: Date? = nil
    @Published var isVersionMatched: Bool?
    
    private var enabled: Bool = true
    @Published var isEnabled: Binding<Bool>?
    
    private var cancellables: [AnyCancellable] = []
    
    private var timer: Timer? = nil
    
    private var peripheral: FXBPeripheral? {
        didSet {
            peripheral?.$state.sink(receiveValue: {
                self.connectionStatusString = $0.humanReadable
                self.connectionStatus = $0
            }).store(in: &cancellables)
        }
    }
    
    init(with thing: FXBDevice, specVersion: String) {
        self.thing = thing
        self.specVersion = specVersion
        
        isEnabled = Binding<Bool>(
            get: { self.enabled },
            set: { newVal in
                self.enabled = newVal
                self.didUpdateEnabled(newVal)
            }
        )
        
        fxb.conn.$centralState.sink(receiveValue: { cbstate in
            switch cbstate {
            case .poweredOn:
                self.peripheral = fxb.conn.peripheral(for: thing.name)
            default: break
            }
        }).store(in: &cancellables)
        
//        timer = Timer.scheduledTimer(
//            withTimeInterval: 0.25,
//            repeats: true,
//            block: { _ in
//                Task { [weak self] in
//                    guard let self = self else { return }
////                    self.lastWrite = await fxb.db.lastDataStreamDate(for: thing)
//                }
//            }
//        )
        
        self.peripheral = fxb.conn.peripheral(for: thing.name)
        self.peripheral?.specVersion.publisher.sink(receiveValue: { [weak self] version in
            self?.isVersionMatched = version == specVersion
            if version != specVersion { self?.enabled = false }
        }).store(in: &cancellables)
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
