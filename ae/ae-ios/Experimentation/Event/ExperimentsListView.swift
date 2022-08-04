//
//  NewExperimentsListView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/3/22.
//

import SwiftUI
import aeble

struct ExperimentsListView: View {
    @StateObject var vm: ExperimentsViewModel
    
    var body: some View {
        List {
            ForEach(vm.experiments, id: \.id) { experiment in
                switch experiment.active {
                case true:
                    NavigationLink(
                        destination: ActiveExperimentView(
                            vm: ExperimentViewModel(experiment),
                            onDismiss: {
                                Task {
                                    await vm.getExperiments()
                                }
                            }
                        )
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarTitle(experiment.name)
                    ) {
                        ExperimentListCellView(vm: ExperimentViewModel(experiment))
                    }
                case false:
                    EmptyView()
                    NavigationLink(
                        destination: InactiveExperimentsView(vm: ExperimentViewModel(experiment))
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationBarTitle(experiment.name)
                    ) {
                        ExperimentListCellView(vm: ExperimentViewModel(experiment))
                    }
                }
            }
            .onDelete { index in
                Task {
                    for offset in index {
                        await vm.deleteExperiment(at: offset)
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}

struct NewExperimentsListView_Previews: PreviewProvider {
    static var previews: some View {
        ExperimentsListView(vm: ExperimentsViewModel())
    }
}
