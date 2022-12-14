//
//  LowPassOptionsView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 11/18/22.
//

import SwiftUI
import flexiBLE_signal

struct LowPassOptionsView: View {
    @Binding var filter: TimeSeries<Float>.FilterType?
    
    @State var cutoff: String
    @FocusState var cutoffFieldIsFocused: Bool
    
    @State var transition: String
    @FocusState var transitionFieldIsFocused: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("Cutoff Frequency (Hz):")
                    .font(.body.bold())
                Spacer()
                TextField(
                    "Float",
                    text: $cutoff
                )
                .frame(width:100)
                .focused($cutoffFieldIsFocused)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .keyboardType(.decimalPad)
                .onSubmit {
                    filter = TimeSeries<Float>.FilterType.lowPass(cutoff: Float(cutoff) ?? 1.0, transition: Float(transition) ?? 1.0)
                }
            }
            
            HStack {
                Text("Transition Frequency (Hz):")
                    .font(.body.bold())
                Spacer()
                TextField(
                    "Float",
                    text: $transition
                )
                .frame(width:100)
                .focused($transitionFieldIsFocused)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .keyboardType(.decimalPad)
                .onSubmit {
                    // TODO: add verification
                    filter = TimeSeries<Float>
                        .FilterType
                        .lowPass(
                            cutoff: Float(cutoff) ?? 1.0,
                            transition: Float(transition) ?? 1.0
                        )
                }
            }
        }
    }
}
