//
//  ProfileSelectionView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 1/30/23.
//

import SwiftUI

struct ProfileSelectionView: View {
    @StateObject var vm: ProfileSelectionViewModel
    
    @State private var showCreate: Bool = false
    
    init(vm: ProfileSelectionViewModel) {
        self._vm = .init(wrappedValue: vm)
    }
    
    var body: some View {
        Group {
            VStack(alignment: .leading) {
                Spacer().frame(height: 16)

                
                HStack {
                    Text("FlexiBLE Profiles")
                        .font(.title)
                    Spacer()
                    Button(
                        action: {
                            showCreate = true
                        },
                        label: {
                            Image(systemName: "plus.app")
                        }
                    ).buttonStyle(PrimaryButtonStyle())
                }
                .sheet(isPresented: $showCreate, content: {
                    CreateProfileFromURLView(vm: vm)
                })
            }.padding()
            
            if vm.profiles.isEmpty {
                Spacer()
                Text("No Profiles").font(.title2)
                Button(
                    action: {
                        showCreate = true
                    },
                    label: {
                        Text("Create a Profile")
                    }
                ).buttonStyle(PrimaryButtonStyle())
                Spacer()
            } else {
                ProfileListView(vm: vm)
            }
            
        }
    }
}

struct ProfileSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSelectionView(vm: ProfileSelectionViewModel())
    }
}
