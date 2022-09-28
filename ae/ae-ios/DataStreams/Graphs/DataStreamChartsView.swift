//
//  DataStreamChartsView.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 9/23/22.
//

import SwiftUI
import Charts

struct DataStreamChartsView: View {
    @StateObject var vm: DataStreamGraphVisualizerViewModel
    @StateObject var graphPropertyVM: DataExplorerGraphPropertyViewModel

    var body: some View {
        Chart {
            ForEach(Array(vm.databResults), id: \.key) { key, value in
                ForEach(value, id: \.ts) {
                    LineMark(
                        x: .value("Time", $0.ts),
                        y: .value("Value", $0.val)
                    )
                }
            }

//            ForEach(vm.databResults, id: \.self) { series in
//                ForEach(series, id: \.ts) {
//                    LineMark(
//                        x: .value("Time", $0.ts),
//                        y: .value("Value", $0.val)
//                    )
//                }
//                .foregroundStyle(by: .value("mark", series.mark))
//            }
        }
//        .chartYScale(domain: graphPropertyVM.getYAxisRange())
        .chartYAxis {
            AxisMarks(preset: .extended, position: .leading) { value in
                AxisGridLine()
                    .foregroundStyle(.gray)
                AxisValueLabel()
                    .foregroundStyle(.black)
            }
        }
        .chartXScale(domain: graphPropertyVM.getXAxisRange())
        .chartXAxis {
            AxisMarks(preset: .automatic, position: .bottom) { value in
                AxisGridLine()
                    .foregroundStyle(.clear)
                if UIDevice.current.orientation == .landscapeRight {
                    AxisValueLabel(horizontalSpacing: 5.0)
                }
            }
        }
    }
}
