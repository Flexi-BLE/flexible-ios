//
//  ExperimentView.swift
//  ntrain-exthub (iOS)
//
//  Created by blaine on 2/28/22.
//

import SwiftUI

struct ExperimentView: View {
    @ObservedObject var vm = ExperimentViewModel()
    
    
    var body: some View {
        
        NavigationView {
            switch vm.state {
            case .loading:
                // TODO: create generic loading view
                Text("Loading ...")
            case .error(error: let error):
                // TODO: create generic error view
                Text("Error: \(error.localizedDescription)")
            case .activeExperiment(experiment: let exp):
                ActiveExperimentView(vm: vm, experiment: exp)
            case .noExperiment:
                NewExperimentView(vm: vm)
            }
        }
        .navigationBarTitle("Experiment")
        .listStyle(GroupedListStyle())
    }
}

struct ExperimentView_Previews: PreviewProvider {
    static var previews: some View {
        ExperimentView()
    }
}
