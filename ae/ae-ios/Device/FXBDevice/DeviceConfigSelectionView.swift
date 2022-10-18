//
//  DeviceConfigSelectionView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/2/22.
//

import SwiftUI

struct DeviceConfigSelectionView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var vm: FlexiBLESpecViewModel
 
    @State private var urlString: String = ""
    @State private var fileNameString: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text("Device Specification URL")
                .font(.title2).bold()
            TextField(
                "Device Config JSON URL",
                text: $urlString
            )
            .onSubmit { load() }
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .border(.primary)
            HStack {
                FXBButton(action: { load() }) {
                    Text("Load")
                }
                FXBButton(action: { dismiss() }) {
                    Text("Cancel")
                }
            }
            Spacer()
        }.onAppear {
            urlString = vm.url?.absoluteString ?? ""
            fileNameString = vm.localFileName ?? ""
        }
    }
    
    private func load() {
        if let url = URL(string: urlString) {
            Task {
                await vm.loadDeviceConfig(with: url)
                self.dismiss()
            }
        } else {
            dismiss()
            vm.state = .error(message: "invalid URL")
        }
    }
}

struct DeviceConfigSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceConfigSelectionView(vm: FlexiBLESpecViewModel())
    }
}
