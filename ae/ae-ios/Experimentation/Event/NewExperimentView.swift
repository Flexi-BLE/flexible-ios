//
//  NewExperimentView.swift
//  ntrain-exthub (iOS)
//
//  Created by blaine on 2/28/22.
//

import SwiftUI

struct NewExperimentView: View {
    var vm: ExperimentViewModel
    @State var name: String = ""
    @State var description: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("Create Experiment")) {
                TextField("name", text: $name)
                TextField("Description", text: $description)
                Button("Create") {
                    Task{
                        await vm.createExperiment(name: name, description: description)
                    }
                }
            }
        }
    }
}

struct NewExperimentView_Previews: PreviewProvider {
    static var previews: some View {
        NewExperimentView(vm: ExperimentViewModel())
    }
}
