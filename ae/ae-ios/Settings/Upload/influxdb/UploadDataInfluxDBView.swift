//
//  UploadDataInfluxDBView.swift
//  Flexi-BLE
//
//  Created by blaine on 9/1/22.
//

import SwiftUI

struct UploadDataInfluxDBView: View {
    var model = InfluxDBConnection.shared
    
    @State var showUploading: Bool = false
    @State var influxDetailsValidated: Bool = false
    
    @State private var continousUploadEnabled: Bool = false
    @State private var uploadInterval: Int = 5
    @State private var maxLookback: Int = 60*60
    @State private var purgeOnUpload: Bool = false
    
    init() {
        _showUploading = .init(initialValue: false)
        _influxDetailsValidated = .init(initialValue: model.validated)
        _continousUploadEnabled = .init(initialValue: model.continousUploadEnabled)
    }
    
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
                                isOn: $continousUploadEnabled,
                                label: { Text("Enable Continuous Upload") })
                            .labelsHidden()
                        }.onChange(of: continousUploadEnabled, initial: false) { oldValue, newValue in
                            model.continousUploadEnabled = newValue
                            influxDetailsValidated = model.validated
                        }
                        
                        
                        if continousUploadEnabled {
                            HStack {
                                Text("Upload Interval")
                                    .font(.callout)
                                    .bold()
                                Spacer()
                                Picker(
                                    "",
                                    selection: $uploadInterval
                                ) {
                                    Text("30 seconds").tag(30)
                                    Text("1 minute").tag(60)
                                    Text("5 minutes").tag(300)
                                    Text("10 minutes").tag(600)
                                    Text("30 minutes").tag(1800)
                                }
                            }.onChange(of: uploadInterval, initial: false) { oldValue, newValue in
                                model.continousUploadInterval = newValue
                                influxDetailsValidated = model.validated
                            }
                            
                            HStack {
                                Text("Max Upload Lookback")
                                    .font(.callout)
                                    .bold()
                                Spacer()
                                Picker(
                                    "",
                                    selection: $maxLookback
                                ) {
                                    Text("1 minute").tag(60)
                                    Text("5 minutes").tag(60*5)
                                    Text("10 minutes").tag(60*10)
                                    Text("30 minutes").tag(60*30)
                                    Text("1 hour").tag(60*60)
                                    Text("5 hours").tag(60*60*5)
                                    Text("12 hours").tag(60*60*12)
                                    Text("24 Hours").tag(60*60*24)
                                }
                            }.onChange(of: maxLookback, initial: false) { oldValue, newValue in
                                model.maxUploadLookback = newValue
                                influxDetailsValidated = model.validated
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
                    }.onAppear(perform: {
                        continousUploadEnabled = model.continousUploadEnabled
                        uploadInterval = model.continousUploadInterval
                        maxLookback = model.maxUploadLookback
                    })
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
        })
    }
}

struct UploadDataInfluxDBView_Previews: PreviewProvider {
    static var previews: some View {
        UploadDataInfluxDBView()
    }
}

