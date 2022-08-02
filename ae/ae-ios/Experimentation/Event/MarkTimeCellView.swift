//
//  MarkTimeCellView.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 8/2/22.
//

import SwiftUI

struct MarkTimeCellView: View {
    var vm: MarkTimeViewModel
    var body: some View {
        Text(vm.name)
            .modifier(Card())
    }
}

struct MarkTimeCellView_Previews: PreviewProvider {
    static var previews: some View {
        MarkTimeCellView(vm: MarkTimeViewModel(
            id: 1,
            name: "Sample Name",
            description: "Sample description",
            experimentID: 2,
            datetime: Date.now)
        )
    }
}
