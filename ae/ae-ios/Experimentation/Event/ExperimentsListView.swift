//
//  NewExperimentsListView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/3/22.
//

import SwiftUI
import FlexiBLE

struct ExperimentsListView: View {
    @EnvironmentObject var profile: FlexiBLEProfile
    @StateObject var vm: ExperimentsViewModel = ExperimentsViewModel()
    
    var body: some View {
        List {
            ForEach(vm.experiments, id: \.id) { experiment in
                switch experiment.active {
                case true:
                    NavigationLink(
                        destination: ActiveExperimentView(
                            vm: ExperimentViewModel(experiment: experiment, database: profile.database),
                            onDismiss: {
                                Task {
                                    await vm.getExperiments()
                                }
                            }
                        )
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarTitle(experiment.name)
                    ) {
                        ExperimentListCellView(vm: ExperimentViewModel(experiment: experiment, database: profile.database))
                    }
                case false:
                    EmptyView()
                    NavigationLink(
                        destination: InactiveExperimentsView(vm: ExperimentViewModel(experiment: experiment, database: profile.database))
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationBarTitle(experiment.name)
                    ) {
                        ExperimentListCellView(vm: ExperimentViewModel(experiment: experiment, database: profile.database))
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
        .onAppear() {
            vm.set(profile: profile)
        }
    }
}

struct NewExperimentsListView_Previews: PreviewProvider {
    static var previews: some View {
        ExperimentsListView()
    }
}
