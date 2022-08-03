//
//  TimeMarkerCellView.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 8/2/22.
//

import SwiftUI

struct TimeMarkerCellView: View {
    @StateObject var vm: TimeMarkerViewModel
    var body: some View {
        NavigationLink(destination: EditTimeMarkerView(vm: vm)) {
            Text(vm.name)
                .foregroundColor(.black)
                .font(.subheadline)
        }
    }
}

struct TimeMarkerCellView_Previews: PreviewProvider {
    static var previews: some View {
        TimeMarkerCellView(vm: TimeMarkerViewModel(
            id: 1,
            name: "Sample Name",
            description: "Sample description",
            experimentID: 2,
            datetime: Date.now)
        )
    }
}
