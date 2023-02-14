//
//  NewExperimentsView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/3/22.
//

import SwiftUI
import FlexiBLE

struct ExperimentsView: View {
    @EnvironmentObject var profile: FlexiBLEProfile
    
    @StateObject private var vm = ExperimentsViewModel()
    @StateObject private var locationManager = LocationManager()
    
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
                        .environmentObject(locationManager)
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarTitle("New Experiment")
                    ) {
                        HStack {
                            Image(systemName: "plus")
                            Text("New")
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
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .onAppear() {
                Task {
                    await vm.getExperiments()
                }
            }
        }
        .onAppear() {
            locationManager.set(database: profile.database)
            vm.set(profile: profile)
        }
    }
}

struct NewExperimentsView_Previews: PreviewProvider {
    static var previews: some View {
        ExperimentsView()
            .environmentObject(FlexiBLE())
    }
}
