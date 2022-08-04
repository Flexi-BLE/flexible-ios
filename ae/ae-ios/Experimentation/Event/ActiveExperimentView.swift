//
//  NewActiveExperimentView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/3/22.
//

import SwiftUI
import aeble

struct ActiveExperimentView: View {
    @StateObject var vm: ExperimentViewModel
    
    @State var nowDate = Date()
    
    var onDismiss: () -> ()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var countupTimer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.nowDate = Date()
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if (vm.experiment.trackGPS) {
                ExperimentMapView(vm: ExperimentMapViewModel(vm.experiment))
            }
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "stop.circle")
                            .resizable()
                            .frame(width: 30.0, height: 30.0)
                            .foregroundColor(.red)
                            .onTapGesture {
                                Task {
                                    await vm.stopExperiment()
                                    self.presentationMode.wrappedValue.dismiss()
                                    self.onDismiss()
                                }
                            }
                                                
                        Image(systemName: "square.and.arrow.up.circle")
                            .resizable()
                            .frame(width: 30.0, height: 30.0)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                Task {
                                    print("TODO Sharing")
                                }
                            }
                        Spacer()
                    }
                    if let description = vm.experiment.description {
                        Text(description)
                            .font(.subheadline)
                    }
                }
            }.padding()
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                KeyValueView(key: "Start Date",value: vm.experiment.start.getDateAndTime())
                KeyValueView(key: "Runtime",value: countDownString(from: vm.experiment.start))
                KeyValueView(key: "End Date", value: vm.experiment.end?.getDateAndTime() ?? "N/A")
                KeyValueView(key: "GPS", value: vm.experiment.trackGPS ? "👌" : "🚫")
            }.padding()
            
            Divider()
            
            VStack(alignment: .leading, spacing: 11) {
                TimestampListView(
                    vm: TimestampsViewModel(with: vm.experiment.id),
                    canCreate: true)
            }.padding()
        }
        .onAppear(perform: {
            _ = self.countupTimer
        })
    }
    
    func countDownString(from date: Date) -> String {
        if date > nowDate {
            return "Yet to begin"
        }
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar
            .dateComponents([.hour, .minute, .second],
                            from: date,
                            to: nowDate)
        return String(format: "%02d:%02d:%02d",
                      abs(components.hour ?? 00),
                      components.minute ?? 00,
                      components.second ?? 00)
    }
}

struct NewActiveExperimentView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveExperimentView(vm: ExperimentViewModel(Experiment.dummyActive()), onDismiss: {})
    }
}
