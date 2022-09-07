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
            Spacer()
            HStack {
                VStack(alignment: .center) {
                    Text("Total Estimated Records").bold().font(.system(size: 10))
                    Text("\(uploader.estNumRecs)").font(.system(size: 18))
                }
                Spacer()
                VStack(alignment: .center) {
                    Text("Total Uploaded").bold().font(.system(size: 10))
                    Text("\(uploader.totalUploaded)").font(.system(size: 18))
                }
            }
//            if #available(iOS 16, *) {
//                Gauge(
//                    value: uploader.progress,
//                    label: { Text("Upload Progress") }
//                )
//            } else {
                Text("\(Int(uploader.progress * 100.0))%")
                .font(.system(size: 55.0))
                Text(uploader.statusMessage)
                    .font(.system(size: 18))
                Spacer()
                FXBButton(
                    action: { uploader.pause() },
                    content: { Text("Pause") }
                )
//            }
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
