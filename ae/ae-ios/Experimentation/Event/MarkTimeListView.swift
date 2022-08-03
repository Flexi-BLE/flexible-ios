//
//  MarkTimeListView.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 8/2/22.
//

import SwiftUI

struct MarkTimeListView: View {
    @ObservedObject var timemarks: TimeMarkersViewModel
    var body: some View {
        List {
            ForEach(timemarks.timestamps, id: \.datetime) { timestamp in
                TimeMarkerCellView(vm: timestamp)
            }
        }
        .listStyle(.plain)
    }
}

struct MarkTimeListView_Previews: PreviewProvider {
    static var previews: some View {
        MarkTimeListView(timemarks: TimeMarkersViewModel(expId: nil))
    }
}
