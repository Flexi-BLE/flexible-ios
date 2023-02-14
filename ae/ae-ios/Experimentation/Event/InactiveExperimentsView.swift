//
//  NewInactiveExperimentsView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/3/22.
//

import SwiftUI
import FlexiBLE

struct InactiveExperimentsView: View {
    @EnvironmentObject var profile: FlexiBLEProfile
    @StateObject var vm: ExperimentViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 29) {
            if (vm.experiment.trackGPS) {
                ExperimentMapView(vm: ExperimentMapViewModel(profile: profile, experiment: vm.experiment))
            }
            
            Text(vm.experiment.description ?? "")
                .font(.subheadline)
                
            
            VStack(alignment: .leading, spacing: 11) {
                Label("Details", systemImage: "info.circle.fill")
                    .font(.title3)
                KeyValueView(key: "Start Date",value: vm.experiment.start.getDateAndTime())
                KeyValueView(key: "End Date", value: vm.experiment.end?.getDateAndTime() ?? "N/A")
                KeyValueView(key: "Elapsed Time", value: vm.elapsedTimeString)
                KeyValueView(key: "Total Records", value: "\(vm.totalRecords.fuzzy)")
            }
            
            VStack(alignment: .leading, spacing: 11) {
                HStack {
                    Label("Time Markers", systemImage: "calendar.badge.clock")
                        .font(.title3)
                    Spacer()
                }
                TimestampListView(
                    vm: TimestampsViewModel(profile: profile, with: vm.experiment.id),
                    canCreate: false
                )
            }
        }
        .padding()
    }
}
