//
//  ProfileSelectionViewModel.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 1/30/23.
//

import Foundation
import Combine
import FlexiBLE

@MainActor class ProfileSelectionViewModel: ObservableObject {
    
    private var flexiBLE: FlexiBLE
    
    enum State {
        case noProfileSelected
        case loading(description: String)
        case active(profile: FlexiBLEProfile)
    }
    
    @Published var state: State = .noProfileSelected
    @Published var errorMessage: String? = nil
    
    var profiles: [FlexiBLEProfile]
    private var observables: [AnyCancellable] = []
    
    init(flexiBLE: FlexiBLE) {
        self.flexiBLE = flexiBLE
        self.profiles = flexiBLE.profiles

        flexiBLE.$profile.sink { profile in
            if let profile = profile {
                self.state = .active(profile: profile)
                self.checkAutoConnect()
            } else {
                self.state = .noProfileSelected
            }
        }.store(in: &observables)
        
        flexiBLE.setLastProfile()
    }
    
    func create(name: String, urlString: String, setActive: Bool) {
        guard let url = URL(string: urlString) else {
            self.errorMessage = "You entered an invalid URL"
            return
        }
        
        self.state = .loading(description: url.lastPathComponent)
        Task {
            if let spec = await loadSpecification(with: url) {
                flexiBLE.createProfile(with: spec, name: name, setActive: setActive)
                if let profile = flexiBLE.profile {
                    profile.startScan()
                    self.profiles = flexiBLE.profiles
                }
            } else {
                errorMessage = "Unable to load remote configuration \(url.lastPathComponent)"
            }  
        }
    }
    
    func setProfile(with id: UUID) {
        flexiBLE.switchProfile(to: id)
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    private func loadSpecification(with url: URL) async -> FXBSpec? {
        if let spec = try? await FXBSpec.load(from: url) {
            return spec
        } else {
            return nil
        }
    }
    
    private func checkAutoConnect() {
        guard let autoConnects: [String] = try? UserDefaults
            .standard
            .getCustomObject(forKey: FXBDeviceViewModel.userDefaultsAutoConnectKey) else  { return }
                
        flexiBLE.profile?.conn.registerAutoConnect(devices: autoConnects)
    }
    
}
