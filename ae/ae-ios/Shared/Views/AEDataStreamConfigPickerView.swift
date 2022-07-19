//
//  AEDataStreamConfigPickerView.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 7/17/22.
//

import SwiftUI
import aeble

struct AEDataStreamConfigPickerView: View {
    @Binding var selectedValue : String
    var values : [AEDataStreamConfigOption]
    var name : String
    var body: some View {
        HStack {
            Text(name)
            Spacer()
            Picker("Selection Options", selection: $selectedValue) {
                ForEach(values, id: \.value) { option in
                    Text(option.name).tag(option.value)
                }
            }
        }
    }
}
