//
//  AEViewModel.swift
//  ae
//
//  Created by blaine on 4/29/22.
//

import Foundation
import Combine
import FlexiBLE

@MainActor class AEViewModel: ObservableObject {
    
    enum State {
        case selected(config: FXBSpec, name: String)
        case unselected
        case loading(name: String)
        case error(message: String)
    }
    
    @Published var state: State
    @Published var url: URL?
    @Published var localFileName: String?
    
    init() {
        state = .unselected
    }
    
    init(with url: URL) {
        self.state = .loading(name: url.absoluteString)
        Task {
            await loadDeviceConfig(with: url)
        }
    }
    
    init(with localFileName: String) {
        state = .loading(name: localFileName)
        Task {
            await loadDeviceConfig(with: localFileName)
        }
    }
    
    func loadDeviceConfig(with url: URL) async {
        self.url = url
        self.state = .loading(name: url.absoluteString)
        
        if let config = try? await FXBSpec.load(from: url) {
            do {
                try await fxb.setSpec(config)
                self.state = .selected(config: config, name: url.absoluteString)
                fxb.startScan(with: config)
            } catch {
                state = .error(message: "unable to store device specification in local database")
            }
        } else {
            state = .error(message: "unable to load remote configuration")
        }
    }
    
    func loadDeviceConfig(with fileName: String) async {
        self.localFileName = fileName
        
        self.state = .loading(name: fileName)
        
        if let config = FXBSpec.load(from: fileName) {
            do {
                try await fxb.setSpec(config)
                self.state = .selected(config: config, name: fileName)
                fxb.startScan(with: config)
            } catch {
                state = .error(message: "unable to store device specification in local database")
            }
        } else {
            self.state = .error(message: "unable to load local config")
        }
    }
}
