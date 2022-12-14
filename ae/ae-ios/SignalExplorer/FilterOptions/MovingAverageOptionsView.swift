//
//  MinMaxScalingOptions.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 11/18/22.
//

import SwiftUI
import Charts
import flexiBLE_signal

struct MovingAverageOptionsView: View {
    @Binding var filter: TimeSeries<Float>.FilterType?
    
    @State var window: String
    @FocusState var windowFieldIsFocused: Bool
    
    var body: some View {
        HStack {
            Text("Window Size:")
                .font(.body.bold())
            Spacer()
            TextField(
                "Integer",
                text: $window
            )
            .frame(width: 100)
            .focused($windowFieldIsFocused)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .keyboardType(.numberPad)
            .onSubmit {
                filter = TimeSeries<Float>.FilterType.movingAverage(window: Int(window) ?? 1)
            }
        }
    }
}
