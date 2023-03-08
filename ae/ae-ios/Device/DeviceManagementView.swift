//
//  DeviceManagementView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 3/8/23.
//

import SwiftUI

struct DeviceManagementView: View {
    private var vm: FXBDeviceViewModel
    
    init(vm: FXBDeviceViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(vm.device.spec.commands, id: \.commandCode) { cmd in
                    ForEach(cmd.appRequests, id: \.code) { req in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(req.name)").font(.title2)
                                Text(req.description).font(.caption)
                            }
                            Spacer()
                            Button {
                                // execute command
                                vm.device.infoServiceHandler()?.send(cmd: cmd, req: req)
                            } label: {
                                Text("Execute")
                            }.buttonStyle(PrimaryButtonStyle())
                        }
                        Divider()
                    }
                }
                Spacer()
            }.padding()
        }
    }
}
