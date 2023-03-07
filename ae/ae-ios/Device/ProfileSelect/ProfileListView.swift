//
//  ProfileListView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 2/27/23.
//

import SwiftUI

struct ProfileListView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    
    var vm: ProfileSelectionViewModel
    @State private var existingSelection: UUID? = nil
    
    var body: some View {
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

struct ProfileListView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileListView(vm: ProfileSelectionViewModel())
    }
}
