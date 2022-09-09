//
//  UploadPausedView.swift
//  Flexi-BLE
//
//  Created by Blaine Rothrock on 9/5/22.
//

import SwiftUI
import FlexiBLE

struct UploadPausedView<T>: View where T: FXBRemoteDatabaseUploader {
    @ObservedObject var uploader: T
    
    var body: some View {
        VStack {
            Spacer()
            Text("⏸ Upload Paused")
            FXBButton(
                action: { uploader.start() },
                content: { Text("Resume") }
            )
            Spacer()
        }.padding()
    }
}

struct UploadPausedView_Previews: PreviewProvider {
    static var previews: some View {
        UploadPausedView(
            uploader: InfluxDBUploader(
                url: URL(string: "https://nasa.gov")!,
                org: "cool",
                bucket: "cool",
                token: "123",
                deviceId: "cool"
            ))
    }
}
