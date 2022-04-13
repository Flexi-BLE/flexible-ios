//
//  ActiveExperimentView.swift
//  ntrain-exthub (iOS)
//
//  Created by blaine on 2/28/22.
//

import SwiftUI
import aeble

struct ActiveExperimentView: View {
    var vm: ExperimentViewModel
    var experiment: Experiment
    
    var body: some View {
        List {
            Section(header: Text("Active Experiment")) {
                KeyValueView(key: "Name", value: experiment.name)
                KeyValueView(key: "Description", value: experiment.description)
                KeyValueView(key: "Start", value: String(describing: experiment.start))
            }
            
            Section(header: Text("Actions")) {
                Button("End Experiment") {
                    Task { await vm.endExperiment() }
                }
                NavigationLink(
                    destination: MarkTime(vm: vm),
                    label: {
                        Text("Mark Time")
                    }
                )
            }
            
            Section(header: Text("Danger Zone")) {
                Button("Delete Experiment") {
                    Task { await vm.deleteExperiment() }
                }
            }
        }
//        VStack(alignment: .leading) {
//            Spacer()
//            Text("Active Experiment")
//                .font(.headline)
//                .bold()
//
//            Divider()
//
//            HStack {
//                Text("Name:")
//                    .bold()
//                Spacer()
//                Text("\(experiment.name)")
//            }
//
//            HStack {
//                Text("Description:")
//                    .bold()
//                Spacer()
//                Text("\(experiment.description ?? "--none--")")
//            }
//
//            HStack {
//                Text("Start Date:")
//                    .bold()
//                Spacer()
//                Text("\(experiment.start)")
//            }
//
//            Button("End Event") {
//                Task {
//                    await vm.endExperiment()
//                }
//            }
//                .padding()
//                .buttonStyle(BorderedProminentButtonStyle())
//
//            Spacer()
//        }.padding()
    }
}

struct ActiveExperimentView_Previews: PreviewProvider {
    static var previews: some View {
        let experiment = Experiment.dummyActive()
        ActiveExperimentView(vm: ExperimentViewModel(), experiment: experiment)
    }
}
