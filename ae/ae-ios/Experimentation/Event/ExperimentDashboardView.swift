//
//  ExperimentDashboardView.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 8/1/22.
//

import SwiftUI

struct ExperimentDashboardView: View {
    @ObservedObject var vm: ExperimentsViewModel = ExperimentsViewModel()
    var body: some View {
        NavigationView {
            VStack {
                HelpHeaderView(title: "Experiments", helpText: "todo...")
                CreateExperimentButtonView(pvm: vm)
                
                switch vm.state {
                case .noExperiment:
                    Text("No active Experiments")
                case .loading:
                    Text("Loading")
                case .error(error: let err):
                    Text(err.localizedDescription)
                case .fetched:
                    ExperimentListDataView(vm: vm)
                }
                Spacer()
            }
        }
    }
}

struct ExperimentDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        ExperimentDashboardView()
    }
}

struct CreateExperimentButtonView: View {
    @ObservedObject var pvm: ExperimentsViewModel
    var body: some View {
        HStack {
            Spacer()
            NavigationLink(destination: NewExperimentView(vm: pvm)) {
                HStack {
                    Image(systemName: "plus")
                    Text("New Experiment")
                        .font(.headline)
                }
                .padding(11)
                .background(Color(UIColor.systemIndigo))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding(12)
    }
}
