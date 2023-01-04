//
//  UploadDataInfluxDBView.swift
//  Flexi-BLE
//
//  Created by blaine on 9/1/22.
//

import SwiftUI

struct UploadDataInfluxDBView: View {
    @StateObject var vm: UploadDataInfluxDBViewModel
    
    var body: some View {
        List {
            Section("InfluxDB Details") {
                VStack(alignment: .leading, spacing: 10) {
                    Group {
                        SimpleBindingTextField(
                            title: "Device Identifier",
                            binding: $vm.deviceId,
                            keyboardType: .default,
                            autoCompletion: false,
                            capitaliation: .never
                        )
                        
                        SimpleBindingTextField(
                            title: "Url",
                            binding: $vm.url,
                            keyboardType: .URL,
                            autoCompletion: false,
                            capitaliation: .never
                        )
                        
                        SimpleBindingTextField(
                            title: "Port",
                            binding: $vm.port,
                            keyboardType: .numberPad,
                            autoCompletion: false,
                            capitaliation: .never
                        )
                        
                        SimpleBindingTextField(
                            title: "Organization",
                            binding: $vm.org,
                            keyboardType: .default,
                            autoCompletion: false,
                            capitaliation: .never
                        )
                       
                        SimpleBindingTextField(
                            title: "Bucket",
                            binding: $vm.bucket,
                            keyboardType: .default,
                            autoCompletion: false,
                            capitaliation: .never
                        )
                        
                        SimpleBindingTextField(
                            title: "Token",
                            binding: $vm.token,
                            keyboardType: .default,
                            autoCompletion: false,
                            capitaliation: .never
                        )
                    }
                }
            }
            
            Section("Continous Upload") {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Enabled")
                            .font(.callout)
                            .bold()
                        Spacer()
                        Toggle(isOn: $vm.continousUploadEnabled, label: { Text("Enable Continuous Upload") })
                            .labelsHidden()
                    }
                    
                    
                    if vm.continousUploadEnabled {
                        HStack {
                            Text("Upload Interval")
                                .font(.callout)
                                .bold()
                            Spacer()
                            Picker("", selection: $vm.continousUploadInterval) {
                                Text("30 seconds").tag("30")
                                Text("1 minute").tag("60")
                                Text("5 minutes").tag("300")
                                Text("10 minutes").tag("600")
                                Text("30 minutes").tag("1800")
                            }
                        }
                        
                        HStack {
                            Text("Purge Records on Upload")
                                .font(.callout)
                                .bold()
                            Spacer()
                            Toggle(isOn: $vm.purgeOnUpload, label: { Text("Purge on Upload") })
                                .labelsHidden()
                        }
                    }
                }
            }

            Section("Upload Details") {
                VStack(alignment: .leading, spacing: 10) {
                    SimpleBindingTextField(
                        title: "Batch Size",
                        binding: $vm.batchSize,
                        keyboardType: .numberPad,
                        autoCompletion: false,
                        capitaliation: .never
                    )
                }
            }
            
            if vm.isReady {
                FXBButton(
                    action: { vm.save() },
                    content: { Text("Upload Now") }
                )
            }
            
        }
        .task {
            vm.validate()
        }
        .sheet(isPresented: $vm.showUploading, onDismiss: {
            vm.influxDBUploader?.pause()
            vm.influxDBUploader = nil
        }, content: {
            DataUploadingView(uploader: RemoteUploadViewModel(uploader: vm.influxDBUploader!))
        })
    }
}

struct UploadDataInfluxDBView_Previews: PreviewProvider {
    static var previews: some View {
        UploadDataInfluxDBView(vm: UploadDataInfluxDBViewModel())
    }
}

