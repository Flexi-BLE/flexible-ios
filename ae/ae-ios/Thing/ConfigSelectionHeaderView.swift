//
//  ConfigSelectionHeaderView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/2/22.
//

import SwiftUI

struct ConfigSelectionHeaderView: View {
    @StateObject var vm: AEViewModel
    
    @State var showConfigSelection = false
    
    var body: some View {
        HStack {
            switch vm.state {
            case .unselected: Group {  }
            case .error(_): Group {  }
            case .selected(let config, _):
                Text("\(config.id) (\(config.schemaVersion))")
                Spacer()
            case .loading(let name):
                Text(name)
                Spacer()
            }
            AEButton {
                showConfigSelection.toggle()
            } content: {
                Text("Select")
            }
            .fullScreenCover(isPresented: $showConfigSelection) {
                DeviceConfigSelectionView(vm: vm)
                    .padding()
            }
        }
    }
}

struct ConfigSelectionHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigSelectionHeaderView(vm: AEViewModel())
    }
}
