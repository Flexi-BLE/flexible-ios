//
//  GraphParameterValueSelectionView.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 9/2/22.
//

import SwiftUI

struct GraphParameterValueSelectionView: View {
    @StateObject var vm: DataValueOptionsListModel
    var body: some View {
        VStack {
            HStack {
                Text("Check values")
                    .bold()
                Spacer()
            }
            List {
                ForEach(vm.values) { value in
                    FXBCheckboxEntry(vm: value)
                }
            }
            .listStyle(.inset)
        }
        .padding()
    }
}

struct GraphParameterValueSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        let data = DataValueOptionInformation(value: "Sample value")
        let vm = DataValueOptionsListModel(withValues: [data])
        GraphParameterValueSelectionView(vm: vm)
    }
}
