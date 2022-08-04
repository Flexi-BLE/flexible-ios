//
//  NewNewExperimentView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/3/22.
//

import SwiftUI

struct NewExperimentView: View {
    @StateObject var vm: NewExperimentViewModel = NewExperimentViewModel()
    
    var onDismiss: () -> ()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Experiment Name")
                        .bold()
                    TextField("Name", text: $vm.name)
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
                    TextField("Description", text: $vm.description)
                            .textFieldStyle(.roundedBorder)
//                    }
                }
                .padding()
                
                VStack(alignment: .leading) {
                    Text("Start Date")
                        .bold()
                    DatePicker("", selection: $vm.startDate,displayedComponents: [.date,.hourAndMinute])
                        .datePickerStyle(.compact)
                        .labelsHidden()
                }
                .padding()
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("End Date")
                            .bold()
                        Spacer()
                        Toggle("Show welcome message", isOn: $vm.hasEndDate)
                            .labelsHidden()
                    }
                    if vm.hasEndDate {
                        DatePicker("", selection: $vm.endDate,displayedComponents: [.date,.hourAndMinute])
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
                        Toggle("Show welcome message", isOn: $vm.trackGPS)
                            .labelsHidden()
                    }
                }
                .padding()
                
                
                HStack {
                    Spacer()
                    AEButton(action: {
                        Task{
                            await vm.createExperiment()
                            self.onDismiss()
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Create")
                    }
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct NewNewExperimentView_Previews: PreviewProvider {
    static var previews: some View {
        NewExperimentView(onDismiss: {})
    }
}
