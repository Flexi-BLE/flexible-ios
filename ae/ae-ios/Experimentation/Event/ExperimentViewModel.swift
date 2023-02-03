//
//  NewExperimentViewModel.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/3/22.
//

import Foundation
import Combine
import FlexiBLE
import SwiftUI


@MainActor class ExperimentViewModel: ObservableObject {
    @Published var experiment: FXBExperiment
    @Published var errorMsg: String?=nil
    @Published var totalRecords: Int = 0
    
    init(_ experiment: FXBExperiment) {
        self.experiment = experiment
        Task {
            await getTotalRecords()
        }
    }
    
    var elapsedTimeString: String {
        guard let end = experiment.end else { return "N/A" }
        
        let diff = Calendar.current.dateComponents(
            [.hour, .minute, .second],
            from: experiment.start,
            to: end
        )
        
        guard let hour = diff.hour,
              let minute = diff.minute,
              let second = diff.second else { return "N/A" }
        
        return String(
            format: "%02ld:%02ld:%02ld",
            hour,
            minute,
            second
        )
    }
    
    func getTotalRecords() async {
        let end = experiment.end ?? Date()
        
        do {
            var count = 0
            let tables = try fxb.dbAccess?.dynamicTable.tableNames() ?? []
            for name in tables {
                count += try await FlexiBLE.shared.dbAccess?
                    .timeseries.count(
                        for: .dynamicData(name: name),
                        start: experiment.start,
                        end: end,
                        deviceName: nil,
                        uploaded: nil
                    ) ?? 0
            }
            self.totalRecords = count
        } catch {
            self.errorMsg = "unable to fetch total record count"
        }
    }
    
    
    
    func stopExperiment() async {
        guard let id = self.experiment.id else { return }
        
        do {
            if let exp = try await FlexiBLE.shared.dbAccess?.experiment.stopExperiment(id: id) {
                experiment = exp
            } else {
                errorMsg = "Unable to find experiment"
            }
        } catch {
            errorMsg = error.localizedDescription
        }
        
        Task {
            await getTotalRecords()
        }
    }
    
    func deleteExperiment() async -> Bool {
        guard let id = self.experiment.id else { return false}
        
        do {
            try await FlexiBLE.shared.dbAccess?.experiment.deleteExperiment(id: id)
            return true
        } catch {
            errorMsg = error.localizedDescription
            return false
        }
    }
}
