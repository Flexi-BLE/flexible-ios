//
//  ProfileSelectionView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 1/30/23.
//

import SwiftUI

struct ProfileSelectionView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var vm: ProfileSelectionViewModel
    
    @State private var urlString: String = ""
    @State private var newProfileName: String = ""
    @State private var existingSelection: UUID? = nil
    
    var body: some View {
        Group {
            VStack(alignment: .leading) {
                Spacer().frame(height: 16)
                Text("Select a Profile").font(.largeTitle)
                Spacer().frame(height: 32)
                
                if case .error(let msg) = vm.state {
                    Text("Error: ").font(.title2).bold()
                    Text(msg)
                    Divider()
                }
                
                CreateProfileFromURLView(vm: vm)
        
                Spacer().frame(height: 16.0)
                Divider()
                Spacer().frame(height: 16.0)
                
                Text("Select an Existing Profile")
                    .font(.title2)
                    .bold()
            }.padding()
            
            if !vm.profiles.isEmpty {
                List(vm.profiles, id: \.id, selection: $existingSelection) { profile in
                    ProfileDetailCell(profile: profile)
                }
                .scrollContentBackground(.hidden)
                .onChange(of: existingSelection) { newValue in
                    if let id = newValue {
                        vm.setProfile(with: id)
                        dismiss()
                    }
                }
            } else {
                Spacer()
                Text("No Existing Profiles").font(.title3).bold()
                Spacer()
            }
        }
    }
}

struct ProfileSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSelectionView(vm: ProfileSelectionViewModel())
    }
}
