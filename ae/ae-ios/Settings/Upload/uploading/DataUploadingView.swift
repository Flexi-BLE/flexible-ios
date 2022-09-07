//
//  DataUploadingView.swift
//  Flexi-BLE
//
//  Created by Blaine Rothrock on 9/1/22.
//

import SwiftUI
import FlexiBLE

struct DataUploadingView<T>: View where T: FXBRemoteDatabaseUploader {
    @ObservedObject var uploader: T
    
    var body: some View {
        switch uploader.state {
        case .notStarted: UploadNotStartedView(uploader: uploader)
        case .initializing: UploadInitializingView(uploader: uploader)
        case .running: UploadRunningView(uploader: uploader)
        case .paused: UploadPausedView(uploader: uploader)
        case .error(let msg): UploadErrorView(uploader: uploader, errorMsg: msg)
        case .done: UploadCompletedView(uploader: uploader)
        }
    }
}

struct UploadingDataView_Previews: PreviewProvider {
    static var previews: some View {
        DataUploadingView(
            uploader: InfluxDBUploader(
                url: URL(string: "https://nasa.gov")!,
                org: "cool",
                bucket: "cool",
                token: "123",
                deviceId: "cool"
            )
        )
    }
}
