//
//  DataStreamChartView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 10/4/22.
//

import SwiftUI
import Charts
import FlexiBLE

struct DataStreamChartView: View {
    @StateObject var vm: DataStreamGraphViewModel
    
    var body: some View {
        ZStack {
            Chart {
                ForEach(Array(vm.data), id: \.key) { key, value in
                    ForEach(vm.yRangeFilter(value), id: \.x) {
                        LineMark(
                                x: .value("Time", $0.x),
                                y: .value("value", $0.y)
                        )
                        .foregroundStyle(by: .value("key", key))
                    }
                    .interpolationMethod(.linear)
                }
            }
            .chartYAxis {
                AxisMarks(preset: .extended, position: .leading) { value in
                    AxisGridLine()
                            .foregroundStyle(.gray)
                    AxisValueLabel()
                            .foregroundStyle(.black)
                }
            }
            .chartXAxis {
                AxisMarks(preset: .automatic, position: .bottom) { value in
                    AxisGridLine().foregroundStyle(.clear)
                    if UIDevice.current.orientation == .landscapeRight {
                        AxisValueLabel()
                    }
                }
            }
            .chartForegroundStyleScale(domain: Array(vm.data.keys).sorted(), range: Color.tab10)
            .chartXScale(domain: vm.chartParameters.xRange)
            .chartYScale(domain: vm.chartParameters.yRange)
            .clipped()
            
            ChartControls(vm: vm)
        }
        .chartXScale(domain: vm.chartParameters.xRange)
        .chartYScale(domain: vm.chartParameters.yRange)
        .clipped()
    }
}

struct DataStreamChartView_Previews: PreviewProvider {
    static var previews: some View {
        DataStreamChartView(
            vm: DataStreamGraphViewModel(
                dataStream: FXBSpec.mock.devices[0].dataStreams[0],
                deviceName: "nothing"
            )
        )
    }
}
