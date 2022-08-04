//
//  NewExperimentsView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/3/22.
//

import SwiftUI

struct ExperimentsView: View {
    @StateObject var vm: ExperimentsViewModel = ExperimentsViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                HelpHeaderView(title: "Experiments", helpText: "todo...")
                
                HStack {
                    Spacer()
                    NavigationLink(
                        destination: NewExperimentView(
                            onDismiss: {
                                Task {
                                    await vm.getExperiments()
                                }
                            }
                        )
                    ) {
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
                
                Spacer()
                switch vm.state {
                case .noExperiment:
                    Text("No active Experiments")
                        .font(.title3)
                case .loading:
                    Text("Loading")
                        .font(.title3)
                case .error(error: let err):
                    Text(err.localizedDescription)
                        .font(.title3)
                case .fetched:
                    ExperimentsListView(vm: vm)
                }
                Spacer()
            }
        }
    }
}

struct NewExperimentsView_Previews: PreviewProvider {
    static var previews: some View {
        ExperimentsView()
    }
}
