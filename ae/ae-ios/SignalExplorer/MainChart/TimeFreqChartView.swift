//
//  TimeFreqChartView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 11/18/22.
//

import SwiftUI
import flexiBLE_signal

struct TimeFreqChartView: View {
    var rawSignal: [(x: Double, y: Float)]
    var filteredSignal: [(x: Double, y: Float)]?
    
    enum ChartDomain {
        case time
        case frequency
    }
    
    @State private var domain: ChartDomain = .time
    @State private var showSrc: Bool = false
    
    private var showSrcImageName: String {
        showSrc ? "circle.dashed.inset.filled" : "circle.dashed"
    }
    
    var body: some View {
        Picker("Domain", selection: $domain.animation(.easeInOut)) {
            Text("Time").tag(ChartDomain.time)
            Text("Frequency").tag(ChartDomain.frequency)
        }
        .pickerStyle(.segmented)
        ZStack {
            switch domain {
            case .frequency:
                ExplorerDetailsFrequencyChart(
                    rawSignal: filteredSignal == nil ? rawSignal : filteredSignal!,
                    filteredSignal: showSrc ? rawSignal : nil
                )
            case .time:
                ExplorerDetailsTimeChart(
                    rawSignal: filteredSignal == nil ? rawSignal : filteredSignal!,
                    filteredSignal: showSrc ? rawSignal : nil
                )
            }
            VStack {
                HStack {
//                    if isUpdating { ProgressView().progressViewStyle(.circular) }
                    Spacer()
                    if let _ = filteredSignal {
                        Button(
                            action: { withAnimation { showSrc.toggle() } },
                            label: { Image(systemName: showSrcImageName) }
                        ).font(.body)
                    }
                }
                Spacer()
            }
        }.frame(height: 180)
    }
}

//struct TimeFreqChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        TimeFreqChartView(ts: TimeSeries<Float>(persistence: 0), colIdx: 0)
//    }
//}
