//
//  GraphParameterValueSelectionView.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 9/2/22.
//

import SwiftUI

struct GraphParameterValueSelectionView: View {
    @State var vm: [DataValueOptionInformation]
    var body: some View {
        VStack {
            HStack {
                Text("Check values")
                    .bold()
                Spacer()
            }
            List {
                ForEach(vm, id: \.value) { value in
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
//        let vm = DataValueOptionsListModelNK(values: [data])
        GraphParameterValueSelectionView(vm: [data])
    }
}
