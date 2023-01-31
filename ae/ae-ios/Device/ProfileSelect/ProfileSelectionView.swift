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
    
    @State private var viewSelection: Int
    
    init(vm: ProfileSelectionViewModel) {
        self._vm = .init(wrappedValue: vm)
        self._viewSelection = .init(wrappedValue: vm.profiles.isEmpty ? 0 : 1)
    }
    
    var body: some View {
        Group {
            VStack(alignment: .leading) {
                Spacer().frame(height: 16)
                
                Group {
                    Text("Select a Profile").font(.largeTitle).bold()
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .font(.title)
                        Text("Switching profiles will disconnect any devices connected in the current profile.")
                            .font(.callout)
                    }
                    Spacer().frame(height: 32)
                    
                }
                
                Picker("", selection: $viewSelection) {
                    Text("New").tag(0)
                    Text("Existing").tag(1)
                }
                .pickerStyle(.segmented)
                .onChange(of: viewSelection) { newValue in
                    vm.clearError()
                }
                
                Spacer().frame(height: 32)
                
                Group {
                    if let errorMessage = vm.errorMessage {
                        Text("Error: ").font(.title2).bold()
                        Text(errorMessage)
                        Divider()
                    }
                }
                
                switch viewSelection {
                case 0:
                    CreateProfileFromURLView(vm: vm)
                case 1:
                    Text("Select an Existing Profile")
                        .font(.title2)
                        .bold()
                    
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
                default: EmptyView()
                }
                
                Spacer()
                
                
            }.padding()
        }
    }
}

struct ProfileSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSelectionView(vm: ProfileSelectionViewModel())
    }
}
