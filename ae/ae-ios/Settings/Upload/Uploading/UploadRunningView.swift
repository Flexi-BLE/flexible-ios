//
//  UploadRunningView.swift
//  Flexi-BLE
//
//  Created by Blaine Rothrock on 9/5/22.
//

import SwiftUI
import FlexiBLE

struct UploadRunningView<T>: View where T: FXBRemoteDatabaseUploader {
    @ObservedObject var uploader: T
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .center) {
                    Text("Total Estimated Records")
                    Text("\(uploader.estNumRecs)")
                }
                Spacer()
                VStack(alignment: .center) {
                    Text("Total Uploaded")
                    Text("\(uploader.totalUploaded)")
                }
            }
            if #available(iOS 16, *) {
                Gauge(value: uploader.progress, label: { Text("Upload Progress") })
            } else {
                Text("\(Int(uploader.progress * 100.0))%")
            }
            Spacer()
        }.padding()
    }
}

struct UploadRunningView_Previews: PreviewProvider {
    static var previews: some View {
        UploadRunningView(
            uploader: InfluxDBUploader(
                url: URL(string: "https://nasa.gov")!,
                org: "cool",
                bucket: "cool",
                token: "123",
                deviceId: "cool"
            ))
    }
}
