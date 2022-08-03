//
//  DeviceConfigSelectionView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/2/22.
//

import SwiftUI

struct DeviceConfigSelectionView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var vm: AEViewModel
    
    @State private var useRemote: Bool = false
 
    @State private var urlString: String = ""
    @State private var fileNameString: String = ""
    
    var body: some View {
        VStack {
            Spacer()
            Toggle(isOn: $useRemote, label: {
                Text("Use Remote Device Config")
            })
            switch useRemote {
            case true:
                TextField(
                    "Device Config JSON URL",
                    text: $urlString
                )
                .onSubmit { load() }
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .border(.primary)
            case false:
                TextField(
                    "Local File Name",
                    text: $fileNameString
                )
                .onSubmit { load() }
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .border(.primary)
            }
            Spacer()
            HStack {
                AEButton(action: { load() }) {
                    Text("Load")
                }
                AEButton(action: { dismiss() }) {
                    Text("Cancel")
                }
            }
        }.onAppear {
            useRemote = vm.localFileName == nil ? true : false
            urlString = vm.url?.absoluteString ?? ""
            fileNameString = vm.localFileName ?? ""
        }
    }
    
    private func load() {
        if useRemote {
            if let url = URL(string: urlString) {
                Task {
                    await vm.loadDeviceConfig(with: url)
                    self.dismiss()
                }
            } else {
                dismiss()
                vm.state = .error(message: "invalid URL")
            }
        } else {
            vm.loadDeviceConfig(with: fileNameString)
            dismiss()
        }
    }
}

struct DeviceConfigSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceConfigSelectionView(vm: AEViewModel())
    }
}
