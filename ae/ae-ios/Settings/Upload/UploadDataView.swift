//
//  UploadDataView.swift
//  Flexi-BLE
//
//  Created by blaine on 9/1/22.
//

import SwiftUI

struct UploadDataView: View {
    @StateObject var vm: UploadDataViewModel = UploadDataViewModel()
    
    
    var body: some View {
        VStack {
        
            HStack {
                Group {
                    Text("Database Target: ")
                        .bold()
                    Picker(selection: $vm.target, label: EmptyView()) {
                        ForEach(UploadDataViewModel.Target.allCases, id: \.self) { t in
                            Text(t.rawValue).tag(t.self)
                        }
                    }
                }.padding()
                Spacer()
            }
            
            VStack(alignment: .leading) {
                Text("Device Identifier")
                    .font(.callout)
                    .bold()
                TextField("Device Id", text: $vm.deviceId)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
            }.padding()
            Divider()
        
            switch vm.target {
            case .influxDB:
                UploadDataInfluxDBView(vm: vm.influxdbVM)
//                NavigationLink {
//                    UploadDataInfluxDBView()
//                } label: {
//                    Text("Config")
//                }.buttonStyle(FCBButtonStyle(bgColor: .indigo, fontColor: .white))

                
            case .questDB:
                UploadDataQuestDBView(vm: vm.questdbVM)
            }
            
            
            Divider()
            
            HStack {
                Spacer()
                FXBButton(
                    action: { vm.save() },
                    content: { Text("Upload") }
                )
                Spacer()
            }.padding()
        }
        .sheet(isPresented: $vm.showUploading, onDismiss: {
            vm.influxDBUploader?.pause()
            vm.influxDBUploader = nil
        }, content: {
            DataUploadingView(uploader: RemoteUploadViewModel(uploader: vm.influxDBUploader!))
        })
    }
}

struct UploadDataView_Previews: PreviewProvider {
    static var previews: some View {
        UploadDataView()
    }
}
