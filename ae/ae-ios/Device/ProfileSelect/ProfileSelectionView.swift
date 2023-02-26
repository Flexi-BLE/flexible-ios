//
//  ProfileSelectionView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 1/30/23.
//

import SwiftUI

struct ProfileSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    
    @StateObject var vm: ProfileSelectionViewModel
    
    @State private var urlString: String = ""
    @State private var newProfileName: String = ""
    @State private var existingSelection: UUID? = nil
    
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
            
            List {
                ForEach(vm.profiles, id: \.id) { profile in
                    ProfileDetailCell(profile: profile)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        existingSelection = profile.id
                    }
                }
                .onDelete(perform: vm.delete)
                .swipeActions(edge: .leading) {
                    Button {
                        var components = URLComponents(url: fxb.appDataPath, resolvingAgainstBaseURL: true)
                        components?.scheme = "shareddocuments"

                        print("Open \(components!.url!)")
                        openURL(components!.url!) { accepted in
                            print(accepted ? "Success" : "Failure")
                        }
                    } label: {
                        Label("Important", systemImage: "square.and.arrow.up")
                    }
                }
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
