//
//  AEDataStreamViewModel.swift
//  ae
//
//  Created by Blaine Rothrock on 4/27/22.
//

import Foundation
import Combine
import SwiftUI
import aeble
import GRDB

@MainActor class AEDataStreamViewModel: ObservableObject {
    @Published var dataStream: AEDataStream
    @Published var recordCount: Int = 0
    @Published var meanFreqLastK: Float = 0
    @Published var unUploadCount: Int = 0
    @Published var uploadAgg: AEBLEDBManager.UploadAggregate = AEBLEDBManager.UploadAggregate(0,0,0)
    
    
    private var timer: Timer?
    private var timerCount: Int = 0
    
    var estimatedReload: Double {
        return Double(dataStream.intendedFrequencyMs * dataStream.batchSize) / 1000.0
    }
    
    init(_ dataStream: AEDataStream) {
        self.dataStream = dataStream
        
        timer = Timer.scheduledTimer(
            withTimeInterval: 5.0,
            repeats: true,
            block: { _ in self.onTimer() }
        )
    }
    
    private func onTimer() {
        Task {
            self.recordCount = await aeble.db.recordCountByIndex(for: dataStream)
            self.unUploadCount = await aeble.db.unUploadedCount(for: dataStream)
            if timerCount % 5 == 0 || timerCount == 1 {
                self.meanFreqLastK = await aeble.db.meanFrequency(for: dataStream)
                self.uploadAgg = await aeble.db.uploadAgg(for: dataStream)
            }
            timerCount += 1
        }
    }
    
    func fetchData<T: AEDataValue & DatabaseValueConvertible>(limit: Int = 1000, offset: Int = 0) async -> [T] {
        return await aeble.db.dataValues(
            for: dataStream.name,
            measurement: dataStream.dataValues[0].name,
            offset: offset,
            limit: limit
        )
    }
}
