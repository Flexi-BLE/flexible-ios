//
//  TimeFreqChartView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 11/18/22.
//

import SwiftUI
import flexiBLE_signal

struct TimeFreqChartView: View {
    @ObservedObject var model: SignalExplorerModel
    var selectedFilter: FilterDetails?=nil
    
    enum ChartDomain {
        case time
        case frequency
        case kernel
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
            if selectedFilter?.selection is IRFilter {
                Text("Kernel").tag(ChartDomain.kernel)
            }
        }
        .pickerStyle(.segmented)
        ZStack {
            switch domain {
            case .frequency:
                if let selectedFilter = selectedFilter, let idx = selectedFilter.dest {
                    ExplorerDetailsFloatChart(
                        signal: model.frequencyDomain(of: model.signalDouble(for: idx)),
                        compareSignal: showSrc ? model.frequencyDomain(of: model.originalSignalDouble) : nil,
                        signalName: "After",
                        compareSignalName: showSrc ? "Before" : nil,
                        xLabel: "Frequency",
                        yLabel: "Amplitude"
                    )
                } else {
                    ExplorerDetailsFloatChart(
                        signal: model.frequencyDomain(of: model.finalSignalDouble),
                        compareSignal: showSrc ? model.frequencyDomain(of: model.originalSignalDouble) : nil,
                        signalName: "Filtered",
                        compareSignalName: showSrc ? "Raw" : nil,
                        xLabel: "Frequency",
                        yLabel: "Amplitude"
                    )
                }
            case .time:
                if let selectedFilter = selectedFilter, let idx = selectedFilter.dest {
                    ExplorerDetailsTimeChart(
                        signal:model.signalDate(for: idx),
                        compareSignal: showSrc ? model.originalSignalDate : nil,
                        signalName: "After",
                        compareSignalName: showSrc ? "Before" : nil,
                        xLabel: "Time",
                        yLabel: "Value"
                    )
                    
                } else {
                    ExplorerDetailsTimeChart(
                        signal: model.finalSignalDate,
                        compareSignal: showSrc ? model.originalSignalDate : nil,
                        signalName: "Filtered",
                        compareSignalName: showSrc ? "Raw" : nil,
                        xLabel: "Time",
                        yLabel: "Value"
                    )
                }
            case .kernel:
                if let selectedFilter = selectedFilter,
                   let irFilt = selectedFilter.selection as? IRFilter,
                   let kernel = irFilt.kernel as? [Float] {
                    
                    ExplorerDetailsFloatChart(
                        signal: model.points(for: kernel),
                        compareSignal: nil,
                        signalName: "Impulse Response",
                        compareSignalName: nil,
                        xLabel: "Sample",
                        yLabel: "Amplitude"
                    )
                }
            }
            VStack {
                HStack {
                    Spacer()
                    if model.filters.count > 0 {
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
