//
//  AddAFilterLink.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 12/14/22.
//

import Foundation
import SwiftUI
import flexiBLE_signal

struct AddAFilterLink: View {
    var model: SignalExplorerModel
    
    @State private var filterType: SignalFilterType = SignalFilterType.none
    
    var body: some View {
        HStack {
            Text("Select a Filter:")
                .font(.body.bold())
            Spacer()
            Picker("Filter Type", selection: $filterType) {
                Text("--").tag(SignalFilterType.none)
                Text("Min Max Scaling").tag(SignalFilterType.minMaxScaling)
                Text("Z-Score Normalization").tag(SignalFilterType.zscore)
                Text("Moving Average").tag(SignalFilterType.movingAverage)
                Text("Low Pass").tag(SignalFilterType.lowPass)
                Text("High Pass").tag(SignalFilterType.highPass)
                Text("Band Pass").tag(SignalFilterType.bandPass)
                Text("Band Reject").tag(SignalFilterType.bandReject)
            }
            .pickerStyle(.menu)
            .labelsHidden()
            .onChange(of: filterType) { newValue in
                guard newValue != .none else { return }
                model.filterAdded(newValue)
                self.filterType = .none
            }
        }
    }
}
