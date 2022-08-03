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
                .onSubmit {
                    if let url = URL(string: urlString) {
                        dismiss()
                        Task {
                            await vm.loadDeviceConfig(with: url)
                        }
                    } else {
                        dismiss()
                        vm.state = .error(message: "invalid URL")
                    }
                }
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .border(.primary)
            case false:
                TextField(
                    "Local File Name",
                    text: $fileNameString
                )
                .onSubmit {
                    vm.loadDeviceConfig(with: fileNameString)
                    dismiss()
                }
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .border(.primary)
            }
            Spacer()
            AEButton(action: { dismiss() }) {
                Text("Dismiss")
            }
        }.onAppear {
            useRemote = vm.localFileName == nil ? true : false
            urlString = vm.url?.absoluteString ?? ""
            fileNameString = vm.localFileName ?? ""
        }
    }
}

struct DeviceConfigSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceConfigSelectionView(vm: AEViewModel())
    }
}
