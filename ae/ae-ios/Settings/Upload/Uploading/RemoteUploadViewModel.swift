//
//  RemoteUploadViewModel.swift
//  Flexi-BLE
//
//  Created by Blaine Rothrock on 9/19/22.
//

import Foundation
import Combine
import FlexiBLE

@MainActor class RemoteUploadViewModel: ObservableObject {
    private let uploader: FXBRemoteDatabaseUploader
    
    @Published var state: FXBDataUploaderState
    @Published var progress: Float
    @Published var estNumRecs: Int
    @Published var totalUploaded: Int
    @Published var batchSize: Int
    @Published var tableStatuses: [FXBTableUploadState]
    
    var timer = Timer.publish(
        every: 0.1,
        on: .main,
        in: .common
    ).autoconnect()
    var timerCancellable: AnyCancellable?
    
    init(uploader: FXBRemoteDatabaseUploader) {
        self.uploader = uploader
        state = uploader.state
        progress = uploader.progress
        estNumRecs = uploader.estNumRecs
        totalUploaded = uploader.totalUploaded
        batchSize = uploader.batchSize
        tableStatuses = uploader.tableStatuses
        
        timerCancellable = timer.sink { _ in
            gLog.debug("uploader tick \(uploader.totalUploaded) (\(self.uploader.state.stringValue))")
            self.state = uploader.state
            self.progress = uploader.progress
            self.estNumRecs = uploader.estNumRecs
            self.totalUploaded = uploader.totalUploaded
            self.batchSize = uploader.batchSize
            self.tableStatuses = uploader.tableStatuses
            
            if uploader.state == .done {
                self.timerCancellable = nil
            }
        }
        
        self.uploader.start()
    }
    
    deinit {
        timer.upstream.connect().cancel()
        timerCancellable = nil
    }
}
