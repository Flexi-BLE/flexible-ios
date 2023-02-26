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
    
    enum State {
        case noProfileSelected
        case loading(description: String)
        case active(profile: FlexiBLEProfile)
    }
    
    @Published var state: State = .noProfileSelected
    @Published var errorMessage: String? = nil
    
    var profiles = fxb.profiles()
    private var observables: [AnyCancellable] = []
    
    init() {
        fxb.$profile.sink { profile in
            if let profile = profile {
                self.state = .active(profile: profile)
                LocationManager.sharedInstance.checkExperiments()
                self.checkAutoConnect()
            } else {
                self.state = .noProfileSelected
            }
        }.store(in: &observables)
        
        fxb.setLastProfile()
    }
    
    func create(name: String, urlString: String, setActive: Bool) {
        guard let url = URL(string: urlString) else {
            self.errorMessage = "You entered an invalid URL"
            return
        }
        
        self.state = .loading(description: url.lastPathComponent)
        Task {
            if let spec = await loadSpecification(with: url) {
                fxb.createProfile(with: spec, name: name, setActive: setActive)
                fxb.startScan(with: spec)
                self.profiles = fxb.profiles()
            } else {
                errorMessage = "Unable to load remote configuration \(url.lastPathComponent)"
            }  
        }
    }
    
    func setProfile(with id: UUID) {
        fxb.switchProfile(to: id)
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    func delete(at offsets: IndexSet) {
        offsets.forEach({
            guard let profile = fxb.profiles()[optional: $0] else { return }
            fxb.delete(profile: profile)
        })
        self.profiles = fxb.profiles()
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
                
        fxb.conn.registerAutoConnect(devices: autoConnects)
    }
    
}
