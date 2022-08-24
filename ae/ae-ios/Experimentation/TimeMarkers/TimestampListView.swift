//
//  NewTimestampListView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/3/22.
//

import SwiftUI
import aeble

struct TimestampListView: View {
    @StateObject var vm: TimestampsViewModel
    
    @State var canCreate: Bool
    
    var body: some View {
        VStack {
            if canCreate {
                HStack {
                    Label("Timemark Details", systemImage: "calendar.badge.clock")
                        .font(.title3)
                    Spacer()
                    AEButton(action: {
                        Task {
                            await vm.createTimemarker()
                        }
                    }, content: {
                        Label("Mark Time", systemImage: "plus")
                    })
                }
            }
            List {
                ForEach(vm.timestamps, id: \.datetime) { timestamp in
                    TimestampCellView(vm: TimestampViewModel(timestamp: timestamp))
                }
            }
            .listStyle(.plain)
        }
    }
}

struct NewMarkTimeListView_Previews: PreviewProvider {
    static var previews: some View {
        TimestampListView(vm: TimestampsViewModel(with: Experiment.dummyActive().id), canCreate: true)
    }
}

