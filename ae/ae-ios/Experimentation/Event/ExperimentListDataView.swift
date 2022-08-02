//
//  ExperimentListDataView.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 8/2/22.
//

import SwiftUI

struct ExperimentListDataView: View {
    @ObservedObject var vm: ExperimentsViewModel
    var body: some View {
        List {
            ForEach(vm.experiments, id: \.id) { experiment in
                if experiment.isActive {
                    NavigationLink(destination: ActiveExperimentView(experiment: experiment, timemarker: MarkTimesViewModel(expId: experiment.id))) {
                        ExperimentListCellView(vm: experiment)
                    }
                } else {
                    NavigationLink(destination: InactiveExperimentView(experiment: experiment, timemarker: MarkTimesViewModel(expId: experiment.id))) {
                        ExperimentListCellView(vm: experiment)
                    }
                }
            }
            .onDelete(perform: deleteExperiment)
        }
        .listStyle(.plain)
    }
    
    func deleteExperiment(at offsets: IndexSet) {
        print("Deleting")
    }
}

struct ExperimentListDataView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ExperimentListDataView(vm:
                ExperimentsViewModel()
//                ExperimentViewModel(
//                    id: 1, name: "Heart rate - ALT",
//                    description: "To measure heart rate while running uphill and capturing other data points and sensor data.",
//                    start: Date(),
//                    end: nil,
//                    active: true
//                ),
//                ExperimentViewModel(
//                    id: 2, name: "Heart rate - GSL",
//                    description: "To measure heart rate while running downhill and capturing other data points and sensor data.",
//                    start: Date(),
//                    end: nil,
//                    active: false
//                )
            )
        }
    }
}
