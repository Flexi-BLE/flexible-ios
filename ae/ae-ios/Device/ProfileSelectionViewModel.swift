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
        case error(message: String)
    }
    @Published var state: State = .noProfileSelected
    
    var profiles = fxb.profiles()
    private var observables: [AnyCancellable] = []
    
    init() {
        fxb.$profile.sink { profile in
            if let profile = profile {
                self.state = .active(profile: profile)
            } else {
                self.state = .noProfileSelected
            }
        }.store(in: &observables)
        fxb.setLastProfile()
    }
    
    func create(name: String, urlString: String) {
        guard let url = URL(string: urlString) else {
            self.state = .error(message: "You entered an invalid URL")
            return
        }
        
        self.state = .loading(description: url.lastPathComponent)
        Task {
            if let spec = await loadSpecification(with: url) {
                fxb.createProfile(with: spec)
                fxb.startScan(with: spec)
                self.profiles = fxb.profiles()
            } else {
                state = .error(message: "unable to load remote configuration \(url.lastPathComponent)")
            }  
        }
    }
    
    func setProfile(with id: UUID) {
        fxb.switchProfile(to: id)
    }
    
    private func loadSpecification(with url: URL) async -> FXBSpec? {
        if let spec = try? await FXBSpec.load(from: url) {
            return spec
        } else {
            return nil
        }
    }
    
}
