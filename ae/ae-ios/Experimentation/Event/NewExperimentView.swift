//
//  NewExperimentView.swift
//  ntrain-exthub (iOS)
//
//  Created by blaine on 2/28/22.
//

import SwiftUI

struct NewExperimentView: View {
    var vm: ExperimentsViewModel
    @State var name: String = ""
    @State var description: String = ""
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @State private var hasEndDate = false
    @State private var trackGPS = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Experiment Name")
                        .bold()
                    TextField("Name", text: $name)
                        .textFieldStyle(.roundedBorder)
                }
                .padding()
                
                VStack(alignment: .leading) {
                    Text("Experiment Description")
                        .bold()
//                    if #available(iOS 16.0, *) {
//                        TextField("Description", text: $description,  axis: .vertical)
//                            .lineLimit(4...10)
//                            .textFieldStyle(.roundedBorder)
//                    } else {
                        TextField("Description", text: $description)
                            .textFieldStyle(.roundedBorder)
//                    }
                }
                .padding()
                
                VStack(alignment: .leading) {
                    Text("Start Date")
                        .bold()
                    DatePicker("", selection: $startDate,displayedComponents: [.date,.hourAndMinute])
                        .datePickerStyle(.compact)
                        .labelsHidden()
                }
                .padding()
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("End Date")
                            .bold()
                        Spacer()
                        Toggle("Show welcome message", isOn: $hasEndDate)
                            .labelsHidden()
                    }
                    if hasEndDate {
                        DatePicker("", selection: $endDate,displayedComponents: [.date,.hourAndMinute])
                            .datePickerStyle(.compact)
                            .labelsHidden()
                    }
                }
                .padding()
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("GPS Tracking")
                            .bold()
                        Spacer()
                        Toggle("Show welcome message", isOn: $trackGPS)
                            .labelsHidden()
                    }
                }
                .padding()
                
                
                HStack {
                    Spacer()
                    AEButton(action: {
                        Task{
                            await vm.createExperiment(
                                name: name,
                                description: description,
                                startDate: startDate,
                                hasEndDate: hasEndDate,
                                endDate: endDate,
                                tracksGPS: trackGPS
                            )
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Create Experiment")
                    }
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct NewExperimentView_Previews: PreviewProvider {
    static var previews: some View {
        NewExperimentView(vm: ExperimentsViewModel())
    }
}
