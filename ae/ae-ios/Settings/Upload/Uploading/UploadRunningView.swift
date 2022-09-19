//
//  UploadRunningView.swift
//  Flexi-BLE
//
//  Created by Blaine Rothrock on 9/5/22.
//

import SwiftUI
import FlexiBLE

struct UploadRunningView: View {
    @ObservedObject var uploader: RemoteUploadViewModel
    
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
//            if #available(iOS 16, *) {
//                Gauge(value: uploader.progress, label: { Text("Upload Progress") })
//            } else {
                Text("\(Int(uploader.progress * 100.0))%")
//            }
            Spacer()
        }.padding()
    }
}
