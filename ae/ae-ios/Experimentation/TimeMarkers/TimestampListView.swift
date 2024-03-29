//
//  NewTimestampListView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/3/22.
//

import SwiftUI
import FlexiBLE

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
                    FXBButton(action: {
                        Task {
                            await vm.createTimemarker()
                        }
                    }, content: {
                        Label("Mark Time", systemImage: "plus")
                    })
                }
            }
            List {
                ForEach(vm.timestamps, id: \.ts) { timestamp in
                    TimestampCellView(vm: TimestampViewModel(timestamp: timestamp))
                }
                .onDelete(perform: vm.delete)
            }
            .listStyle(.plain)
        }
    }
}

struct NewMarkTimeListView_Previews: PreviewProvider {
    static var previews: some View {
        TimestampListView(vm: TimestampsViewModel(with: FXBExperiment.dummyActive().id), canCreate: true)
    }
}

