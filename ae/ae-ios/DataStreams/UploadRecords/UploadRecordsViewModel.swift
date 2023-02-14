//
//  UploadRecordsViewModel.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 2/2/23.
//

import Foundation
import SwiftUI
import Combine
import FlexiBLE


@MainActor class UploadRecordsViewModel: ObservableObject {
    
    var dataStream: String?
    private var uploadPub: AnyPublisher<[FXBDataUpload], any Error>?
    private var cancellables = Set<AnyCancellable>()
    
    @Published var uploadRecords: [FXBDataUpload] = []
    
    init(profile: FlexiBLEProfile, dataStream: String?) {
        self.dataStream = dataStream
        uploadPub = try? profile.database.dataUpload.publisher(table: dataStream)
        uploadPub?.sink(receiveCompletion: { comp in
            // TODO
        }, receiveValue: { recs in
            withAnimation() {
                self.uploadRecords = recs
            }
        })
        .store(in: &cancellables)
    }
}
