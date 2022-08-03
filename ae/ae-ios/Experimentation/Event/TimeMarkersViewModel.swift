//
//  TimeMarkersViewModel.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 8/2/22.
//

import Foundation

@MainActor class TimeMarkersViewModel: ObservableObject {
    @Published var timestamps: [TimeMarkerViewModel]
    
    init(expId: Int64?) {
        self.timestamps = []
        Task {
            await self.getTimestamps(forID: expId)
        }
    }
    
    func getTimestamps(forID: Int64?) async {
        guard let id = forID else {
            return
        }
        let res = await aeble.exp.getTimestampForExperiment(withID: id)
        switch res {
        case .success(let ts):
            guard let stamps = ts else {
                return
            }
            for stamp in stamps {
                let timestamp = TimeMarkerViewModel(id: stamp.id, name: stamp.name ?? "N/A", description: stamp.description ?? "--", experimentID: id, datetime: stamp.datetime)
                self.timestamps.append(timestamp)
            }
        case .failure(let err):
            print(err.localizedDescription)
        }
    }
    
    
    func createTimemarker(id: Int64?) async {
        let name = "Timestamp - \(Date().getDetailedDate())"
        let res = await aeble.exp.createTimeMarkers(name: name, experimentId: id)
        
        switch res {
        case .success(let ts):
            let marker = TimeMarkerViewModel(id: ts.id, name: ts.name ?? name, description: ts.description ?? "--", experimentID: ts.experimentId, datetime: ts.datetime)
            self.timestamps.append(marker)
        case .failure(let err):
            print(err.localizedDescription)
        }
    }
}
