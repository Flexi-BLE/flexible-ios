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
    @Published var statusMessage: String
    
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
        statusMessage = uploader.statusMessage
        
        timerCancellable = timer.sink { _ in
            gLog.debug("uploader tick \(uploader.totalUploaded) (\(self.uploader.state.stringValue))")
            self.state = uploader.state
            self.progress = uploader.progress
            self.estNumRecs = uploader.estNumRecs
            self.totalUploaded = uploader.totalUploaded
            self.statusMessage = uploader.statusMessage
            
            switch uploader.state {
            case .done, .paused, .error(_): self.timerCancellable = nil
            default: break
            }
        }
        
        Task {
            await self.uploader.upload()
        }
    }
    
    deinit {
        timer.upstream.connect().cancel()
        timerCancellable = nil
    }
    
    func start() {
        Task {
            await self.uploader.upload()
        }
    }
    
    func pause() {
        uploader.pause()
    }
}
