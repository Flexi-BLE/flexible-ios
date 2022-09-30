//
//  ConfigSelectionHeaderView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/2/22.
//

import SwiftUI

struct ConfigSelectionHeaderView: View {
    @StateObject var vm: FlexiBLESpecViewModel
    
    @State var showConfigSelection = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("DEVICE SPECIFICATION").font(.system(size: 10))
                switch vm.state {
                case .unselected: Text("--None--").font(.body)
                case .error(_): Group {  }
                case .selected(let config, _):
                    Text("\(config.id) (\(config.schemaVersion))").font(.body)
                case .loading(let name):
                    Text(name)
                }
            }
            Spacer()
            FXBButton {
                showConfigSelection.toggle()
            } content: {
                Text("Select")
            }
            .sheet(isPresented: $showConfigSelection) {
                DeviceConfigSelectionView(vm: vm)
                    .padding()
            }
        }
    }
}

struct ConfigSelectionHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigSelectionHeaderView(vm: FlexiBLESpecViewModel())
    }
}
