//
//  NewTimestampListView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/3/22.
//

import SwiftUI
import FlexiBLE

struct TimestampListView: View {
    @EnvironmentObject var profile: FlexiBLEProfile
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
                    TimestampCellView(vm: TimestampViewModel(database: profile.database, timestamp: timestamp))
                }
            }
            .listStyle(.plain)
        }
    }
}
