//
//  UploadingDataView.swift
//  Flexi-BLE
//
//  Created by Blaine Rothrock on 9/1/22.
//

import SwiftUI
import FlexiBLE

struct UploadingDataView<T>: View where T: FXBRemoteDatabaseUploader {
    @ObservedObject var uploader: T
    
    var body: some View {
        Text("cool")
    }
}

struct UploadingDataView_Previews: PreviewProvider {
    static var previews: some View {
        UploadingDataView(uploader: InfluxDBUploader(
            url: URL(string: "https://nasa.gov")!,
            org: "cool",
            bucket: "cool",
            token: "123")
        )
    }
}
