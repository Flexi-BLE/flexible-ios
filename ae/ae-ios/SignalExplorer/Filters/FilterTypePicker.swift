//
//  FilterTypePicker.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 11/18/22.
//

import SwiftUI
import flexiBLE_signal

struct FilterTypePicker: View {
    @Binding var filterType: SignalFilterType

    var body: some View {
        Picker("Filter Type", selection: $filterType) {
            Text("None").tag(SignalFilterType.none.rawValue)
            Text("Min Max Scaling").tag(SignalFilterType.minMaxScaling.rawValue)
            Text("Z-Score Normalization").tag(SignalFilterType.zscore.rawValue)
            Text("Moving Average").tag(SignalFilterType.movingAverage.rawValue)
            Text("Low Pass").tag(SignalFilterType.lowPass.rawValue)
            Text("High Pass").tag(SignalFilterType.highPass.rawValue)
            Text("Band Pass").tag(SignalFilterType.bandPass.rawValue)
            Text("Band Reject").tag(SignalFilterType.bandReject.rawValue)
        }
        .pickerStyle(.menu)
    }
}
