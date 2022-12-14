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
    
    private var uploadTarget: UploadDataViewModel.Target = UploadDataViewModel.Target(
        rawValue: UserDefaults
            .standard
            .string(
                forKey: UploadDataViewModel
                    .UserDefaultsKey.dbTarget.rawValue
            ) ?? UploadDataViewModel.Target.influxDB.rawValue)!
    
    private var deviceId: String = UserDefaults.standard.string(
        forKey: UploadDataViewModel.UserDefaultsKey.deviceId.rawValue
    ) ?? UIDevice.current.id
    
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
            self.totalRecords = try await fxb.read.getTotalRecords(from: experiment.start, to: end)
        } catch {
            self.errorMsg = "unable to fetch total record count"
        }
    }
    
    
    
    func stopExperiment() async {
        guard let id = self.experiment.id else { return }
        
        let res = await fxb.exp.stopExperiment(id: id)
        
        switch res {
        case .success(let exp):
            self.experiment = exp
        case .failure(let e):
            errorMsg = e.localizedDescription
        }
        
        Task {
            await getTotalRecords()
        }
    }
    
    func deleteExperiment() async -> Bool {
        guard let id = self.experiment.id else { return false}
        
        let res = await fxb.exp.deleteExperiment(id: id)
        
        switch res {
        case .success(let status):
            print(status)
            return status
        case .failure(let error):
            print(error.localizedDescription)
            return false
        }
    }
    
    func uploadModel() -> FXBRemoteDatabaseUploader? {
        switch uploadTarget {
        case .influxDB:
            let influxVM = UploadDataInfluxDBViewModel()
            if influxVM.isReady {
                return InfluxDBUploader(
                    url: URL(string: "\(influxVM.url):\(influxVM.port)/api/v2/write")!,
                    org: influxVM.org,
                    bucket: influxVM.bucket,
                    token: influxVM.token,
                    startDate: experiment.start.addingTimeInterval(-30),
                    endDate: experiment.end?.addingTimeInterval(30) ?? Date.now,
                    deviceId: deviceId
                )
            }
        case .questDB:
            return nil
        }
        return nil
    }
}
