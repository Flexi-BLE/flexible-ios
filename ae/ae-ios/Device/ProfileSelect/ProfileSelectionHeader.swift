//
//  ProfileSelectionHeader.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 1/30/23.
//

import SwiftUI
import FlexiBLE

struct ProfileSelectionHeader: View {
    
    @StateObject var vm: ProfileSelectionViewModel
    @State private var showSwitch: Bool = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("PROFILE").font(.system(size: 10))
                switch vm.state {
                case .noProfileSelected: Text("No Profile Selected").font(.body)
                case .active(let profile):
                    Text("\(profile.name)").font(.body).bold()
                    Text("\(profile.id)").font(.system(size: 10))
                case .loading(let desc):
                    Text("Loading: \(desc)").font(.body)
                }
            }
            Spacer()
            FXBButton {
                showSwitch.toggle()
            } content: {
                Text("Switch")
            }
            .sheet(isPresented: $showSwitch) {
                ProfileSelectionView(vm: vm)
            }
        }
    }
}

struct ProfileSelectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSelectionHeader(vm: ProfileSelectionViewModel(flexiBLE: FlexiBLE()))
    }
}
