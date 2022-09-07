//
//  UploadErrorView.swift
//  Flexi-BLE
//
//  Created by Blaine Rothrock on 9/5/22.
//

import SwiftUI
import FlexiBLE

struct UploadErrorView<T>: View where T: FXBRemoteDatabaseUploader {
    @ObservedObject var uploader: T
    let errorMsg: String
    
    var body: some View {
        VStack {
            Spacer()
            Text("⚠️ Error Uploading Records ⚠️").bold()
            Text(errorMsg)
            Spacer()
        }.padding()
    }
}

struct UploadErrorView_Previews: PreviewProvider {
    static var previews: some View {
        UploadErrorView(
            uploader: InfluxDBUploader(
                url: URL(string: "https://nasa.gov")!,
                org: "cool",
                bucket: "cool",
                token: "123",
                deviceId: "cool"
            ),
            errorMsg: "oops"
        )
    }
}
