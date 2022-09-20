//
//  DataUploadingView.swift
//  Flexi-BLE
//
//  Created by Blaine Rothrock on 9/1/22.
//

import SwiftUI
import FlexiBLE
import Combine

struct DataUploadingView: View {
    @ObservedObject var uploader: RemoteUploadViewModel
    
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
