//
//  UploadInitializingView.swift
//  Flexi-BLE
//
//  Created by Blaine Rothrock on 9/5/22.
//

import SwiftUI
import FlexiBLE

struct UploadInitializingView<T>: View where T: FXBRemoteDatabaseUploader {
    @ObservedObject var uploader: T
    
    var body: some View {
        VStack {
            Spacer()
            Text("⏳Initializing Upload")
            Spacer()
        }.padding()
    }
}

struct UploadInitializingView_Previews: PreviewProvider {
    static var previews: some View {
        UploadInitializingView(
            uploader: InfluxDBUploader(
                url: URL(string: "https://nasa.gov")!,
                org: "cool",
                bucket: "cool",
                token: "123",
                deviceId: "cool"
            ))
    }
}
