//
//  MarkTimeListView.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 8/2/22.
//

import SwiftUI

struct MarkTimeListView: View {
    @ObservedObject var markTimes: MarkTimesViewModel
    var body: some View {
        List {
            ForEach(markTimes.timestamps, id: \.datetime) { timestamp in
                MarkTimeCellView(vm: timestamp)
            }
        }
        .listStyle(.plain)
    }
}

struct MarkTimeListView_Previews: PreviewProvider {
    static var previews: some View {
        MarkTimeListView(markTimes: MarkTimesViewModel(expId: 0))
    }
}
