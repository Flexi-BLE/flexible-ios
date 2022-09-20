//
//  UploadErrorView.swift
//  Flexi-BLE
//
//  Created by Blaine Rothrock on 9/5/22.
//

import SwiftUI
import FlexiBLE

struct UploadErrorView: View {
    @ObservedObject var uploader: RemoteUploadViewModel
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
