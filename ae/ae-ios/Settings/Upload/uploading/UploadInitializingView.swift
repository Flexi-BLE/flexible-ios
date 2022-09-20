//
//  UploadInitializingView.swift
//  Flexi-BLE
//
//  Created by Blaine Rothrock on 9/5/22.
//

import SwiftUI
import FlexiBLE

struct UploadInitializingView: View {
    @ObservedObject var uploader: RemoteUploadViewModel
    
    var body: some View {
        VStack {
            Spacer()
            Text("⏳Initializing Upload")
            Spacer()
        }.padding()
    }
}
