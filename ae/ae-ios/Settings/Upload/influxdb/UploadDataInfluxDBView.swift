//
//  UploadDataInfluxDBView.swift
//  Flexi-BLE
//
//  Created by blaine on 9/1/22.
//

import SwiftUI

struct UploadDataInfluxDBView: View {
    @EnvironmentObject var model: InfluxDBConnection
    
    @State var showUploading: Bool = false
    @State var influxDetailsValidated: Bool = false
    @State var continousUploadEnabled: Bool = false
    
    var body: some View {
        List {
            Section("InfluxDB Details") {
                VStack(alignment: .leading, spacing: 10) {
                    Group {
                        SimpleBindingTextField(
                            title: "Device Identifier",
                            text: model.deviceId,
                            keyboardType: .default,
                            autoCompletion: false,
                            capitaliation: .never,
                            onChange: {
                                model.deviceId = $0
                                influxDetailsValidated = model.validated
                            }
                        )
                        
                        SimpleBindingTextField(
                            title: "Base Url",
                            text: model.urlString,
                            keyboardType: .URL,
                            autoCompletion: false,
                            capitaliation: .never,
                            onChange: {
                                model.urlString = $0
                                influxDetailsValidated = model.validated
                            }
                        )
                        
                        SimpleBindingTextField(
                            title: "Port",
                            text: "\(model.port)",
                            keyboardType: .numberPad,
                            autoCompletion: false,
                            capitaliation: .never,
                            onChange: {
                                if let port = Int($0) { model.port = port }
                                influxDetailsValidated = model.validated
                            }
                        )
                        
                        SimpleBindingTextField(
                            title: "Organization",
                            text: model.org,
                            keyboardType: .default,
                            autoCompletion: false,
                            capitaliation: .never,
                            onChange: {
                                model.org = $0
                                influxDetailsValidated = model.validated
                            }
                        )
                       
                        SimpleBindingTextField(
                            title: "Bucket",
                            text: model.bucket,
                            keyboardType: .default,
                            autoCompletion: false,
                            capitaliation: .never,
                            onChange: {
                                model.bucket = $0
                                influxDetailsValidated = model.validated
                            }
                        )
                        
                        SimpleBindingTextField(
                            title: "Token",
                            text: model.token,
                            keyboardType: .default,
                            autoCompletion: false,
                            capitaliation: .never,
                            onChange: {
                                model.token = $0
                                influxDetailsValidated = model.validated
                            }
                        )
                    }
                }
            }
            
            if influxDetailsValidated {
                
                Section("Continous Upload") {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Enabled")
                                .font(.callout)
                                .bold()
                            Spacer()
                            Toggle(
                                isOn: Binding<Bool>(
                                    get: { model.continousUploadEnabled },
                                    set: {
                                        model.continousUploadEnabled = $0
                                        continousUploadEnabled = $0
                                         influxDetailsValidated = model.validated
                                    }
                                ),
                                label: { Text("Enable Continuous Upload") })
                            .labelsHidden()
                        }
                        
                        
                        if continousUploadEnabled {
                            HStack {
                                Text("Upload Interval")
                                    .font(.callout)
                                    .bold()
                                Spacer()
                                Picker(
                                    "",
                                    selection: Binding<Int>(
                                        get: { model.continousUploadInterval },
                                        set: {
                                            model.continousUploadInterval = $0
                                            influxDetailsValidated = model.validated
                                        }
                                    )
                                ) {
                                    Text("30 seconds").tag(30)
                                    Text("1 minute").tag(60)
                                    Text("5 minutes").tag(300)
                                    Text("10 minutes").tag(600)
                                    Text("30 minutes").tag(1800)
                                }
                            }
                            
                            HStack {
                                Text("Purge Records on Upload")
                                    .font(.callout)
                                    .bold()
                                Spacer()
                                Toggle(
                                    isOn: Binding<Bool>(
                                        get: { model.purgeOnUpload },
                                        set: { model.purgeOnUpload = $0 }
                                    ),
                                    label: { Text("Purge on Upload") }
                                )
                                .labelsHidden()
                            }
                        }
                    }
                }
            }
                

            Section("Upload Details") {
                VStack(alignment: .leading, spacing: 10) {
                    SimpleBindingTextField(
                        title: "Batch Size",
                        text: "\(model.batchSize)",
                        keyboardType: .numberPad,
                        autoCompletion: false,
                        capitaliation: .never,
                        onChange: {
                            if let batchSize = Int($0) {
                                model.batchSize = batchSize
                            }
                        }
                    )
                }
            }
            
            if model.validated {
                FXBButton(
                    action: { showUploading = true },
                    content: { Text("Upload Now") }
                )
            }
            
        }
        .sheet(isPresented: $showUploading, onDismiss: {
            
        }, content: {
            if let uploader = model.uploader(start: nil, end: Date.now) {
                DataUploadingView(uploader: RemoteUploadViewModel(uploader: uploader))
            } else {
                Text("uh oh")
            }
        }).onAppear() {
            influxDetailsValidated = model.validated
            continousUploadEnabled = model.continousUploadEnabled
        }
    }
}

struct UploadDataInfluxDBView_Previews: PreviewProvider {
    static var previews: some View {
        UploadDataInfluxDBView()
    }
}

