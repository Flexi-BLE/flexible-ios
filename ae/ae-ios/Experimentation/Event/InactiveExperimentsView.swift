//
//  NewInactiveExperimentsView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/3/22.
//

import SwiftUI
import FlexiBLE

struct InactiveExperimentsView: View {
    @StateObject var vm: ExperimentViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 29) {
            if (vm.experiment.trackGPS) {
                ExperimentMapView(vm: ExperimentMapViewModel(vm.experiment))
            }
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    HStack {
//                        Text(vm.experiment.name)
//                            .font(.title)
                        Spacer()
                        Image(systemName: "stop.circle")
                            .font(.title)
                        Image(systemName: "square.and.arrow.up.circle")
                            .font(.title)
                    }
                    Text(vm.experiment.description ?? "")
                        .font(.subheadline)
                }
            }
            
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
                    vm: TimestampsViewModel(with: vm.experiment.id),
                    canCreate: false
                )
            }
        }
        .padding()
    }
}

struct NewInactiveExperimentsView_Previews: PreviewProvider {
    static var previews: some View {
        InactiveExperimentsView(vm: ExperimentViewModel(FXBExperiment.dummyActive()))
    }
}
