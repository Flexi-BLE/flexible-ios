//
//  InactiveExperimentView.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 8/2/22.
//

import SwiftUI

struct InactiveExperimentView: View {
    var experiment: ExperimentViewModel
    @ObservedObject var timemarker: TimeMarkersViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 29) {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    HStack {
                        Text(experiment.name)
                            .font(.title)
                        Spacer()
                        Image(systemName: "stop.circle")
                            .font(.title)
                        Image(systemName: "square.and.arrow.up.circle")
                            .font(.title)
                    }
                    Text(experiment.description ?? "")
                        .font(.subheadline)
                }
            }
            
            VStack(alignment: .leading, spacing: 11) {
                Label("Experiment Details", systemImage: "info.circle.fill")
                    .font(.title3)
                KeyValueView(key: "Start Date",value: experiment.startDate.getShortDate())
                KeyValueView(key: "End Date", value: experiment.endDate?.getShortDate() ?? "N/A")
            }
            
            VStack(alignment: .leading, spacing: 11) {
                HStack {
                    Label("Timemark Details", systemImage: "calendar.badge.clock")
                        .font(.title3)
                    Spacer()
                }
                MarkTimeListView(timemarks: timemarker)
            }
        }
        .padding()
    }
}

struct InactiveExperimentView_Previews: PreviewProvider {
    static var previews: some View {
        InactiveExperimentView(experiment: ExperimentViewModel(
            id: 312, name: "Sample Name",
            description: "Sample Description for the selected experiment and it is a long one at that.",
            start: Date(),
            end: Date(),
            active: true), timemarker: TimeMarkersViewModel(expId: nil))
    }
}
