//
//  UploadCompletedView.swift
//  Flexi-BLE
//
//  Created by Blaine Rothrock on 9/5/22.
//

import SwiftUI
import FlexiBLE

struct UploadNotStartedView: View {
    @ObservedObject var uploader: RemoteUploadViewModel
    
    var body: some View {
        VStack {
            Spacer()
            Text("Upload waiting to start")
            Spacer()
        }.padding()
    }
}
