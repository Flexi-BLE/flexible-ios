//
//  ActiveExperimentView.swift
//  ntrain-exthub (iOS)
//
//  Created by blaine on 2/28/22.
//

import SwiftUI
import aeble

struct ActiveExperimentView: View {
    @ObservedObject var experiment: ExperimentViewModel
    @ObservedObject var timemarker: TimeMarkersViewModel
    @State var nowDate = Date()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var countupTimer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.nowDate = Date()
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 35) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 11) {
                    HStack {
                        Text(experiment.name)
                            .font(.title)
                        Spacer()
                        
                        Image(systemName: "stop.circle")
                            .font(.title)
                            .foregroundColor(.red)
                            .onTapGesture {
                                Task {
                                    await experiment.stopExperiment()
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            }
                                                
                        Image(systemName: "square.and.arrow.up.circle")
                            .font(.title)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                Task {
                                    print("TODO Sharing")
                                }
                            }
                    }
                    Text(experiment.description ?? "")
                        .font(.subheadline)
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 17) {
                Label("Experiment Details", systemImage: "info.circle.fill")
                    .font(.title3)
                VStack(alignment: .leading, spacing: 9) {
                    KeyValueView(key: "Start Date",value: experiment.startDate.getDateAndTime())
                    KeyValueView(key: "Runtime",value: countDownString(from: experiment.startDate))
                    KeyValueView(key: "End Date", value: experiment.endDate?.getDateAndTime() ?? "N/A")
                    KeyValueView(key: "GPS", value: "🚫")
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 11) {
                HStack {
                    Label("Timemark Details", systemImage: "calendar.badge.clock")
                        .font(.title3)
                    Spacer()
                    AEButton(action: {
                        Task {
                            await timemarker.createTimemarker(id: experiment.id)
                        }
                    }, content: {
                        Label("Mark Time", systemImage: "plus")
                    })
                }
                MarkTimeListView(timemarks: timemarker)
            }
        }
        .padding()
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

struct ActiveExperimentView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveExperimentView(experiment: ExperimentViewModel(
            id: 312, name: "Sample Name",
            description: "Sample Description for the selected experiment and it is a long one at that.",
            start: Date(),
            end: Date(),
            active: true), timemarker: TimeMarkersViewModel(expId: nil)
        )
    }
}
