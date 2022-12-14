//
//  FilterEditChartView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 12/7/22.
//

import SwiftUI

struct FilterEditChartView: View {
    var rawSignal: [(x: Double, y: Float)]
    var filteredSignal: [(x: Double, y: Float)]?
    var kernel: [(x: Float, y: Float)]?
    
    private enum ChartDomain {
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
            Text("Kernel").tag(ChartDomain.kernel)
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
            case .kernel: EmptyView()
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

//struct FilterEditChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        FilterEditChartView()
//    }
//}
