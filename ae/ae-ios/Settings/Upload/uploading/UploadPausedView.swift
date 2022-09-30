//
//  UploadPausedView.swift
//  Flexi-BLE
//
//  Created by Blaine Rothrock on 9/5/22.
//

import SwiftUI
import FlexiBLE

struct UploadPausedView: View {
    @ObservedObject var uploader: RemoteUploadViewModel
    
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
