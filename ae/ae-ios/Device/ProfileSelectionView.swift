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
    @State private var existingSelection: UUID? = nil
    
    var body: some View {
        Group {
            VStack(alignment: .leading) {
                Spacer().frame(height: 16)
                Text("Select a Profile").font(.largeTitle)
                Spacer().frame(height: 16)
                
                if case .error(let msg) = vm.state {
                    Text("Error: ").font(.title2)
                    Text(msg)
                    Divider()
                }
                
                Text("Create a new profile")
                    .font(.title2)
                Text("Enter a FlexiBLE Specification URL")
                    .font(.body)
                TextField(
                    "Device Config JSON URL",
                    text: $urlString
                )
                .onSubmit {
                    vm.load(from: urlString)
                    dismiss()
                }
                .keyboardType(.URL)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .border(.primary)
        
                Divider()
                
                Text("Select an Existing Profile")
                    .font(.title2)
            }.padding()
            
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
        }
    }
}

struct ProfileSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSelectionView(vm: ProfileSelectionViewModel())
    }
}
