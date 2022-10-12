//
//  ConfigBitEncodingMultiselectEditView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 10/11/22.
//

import SwiftUI
import FlexiBLE

struct ConfigBitEncodingMultiselectEditView: View {
    @StateObject var vm: ConfigViewModel
    @State private var isSelecting: Bool = false
    
    var body: some View {
        if let options = vm.config.options {
            VStack(alignment: .leading) {
                
                Text(vm.config.name)
                    .bold()
                    .font(.title3)
                Text(vm.config.description)
                
                Spacer().frame(width: 16.0)
                HStack {
                    if vm.multiSelectSelections.count > 0 {
                        Text("Selected: ").bold()
                        Text("\(vm.multiSelectSelections.joined(separator: ", "))")
                            .lineLimit(nil)
                    } else {
                        Text("--none selected--")
                    }
                    Spacer()
                    FXBButton(
                        action: { isSelecting.toggle() },
                        content: { Text("Select") }
                    )
                }
                
            }
            .popover(isPresented: $isSelecting) {
                MultiSelectionView(
                    title: vm.config.name,
                    selections: vm.multiSelectSelections,
                    options: options.map({ $0.name }),
                    didSelect: { vm.selectOption(named: $0) },
                    didDeselect: { vm.deselectOption(named: $0) }
                )
            }
        }
    }
}

struct ConfigBitEncodingMultiselectView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigBitEncodingMultiselectEditView(
            vm: ConfigViewModel(config: FXBSpec.mock.devices[0].dataStreams[0].configValues[0])
        )
    }
}
