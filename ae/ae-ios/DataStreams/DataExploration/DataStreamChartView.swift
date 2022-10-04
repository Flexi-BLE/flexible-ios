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
        Chart {
            ForEach(Array(vm.data), id: \.key) { key, value in
                ForEach(value, id: \.x) {
                    LineMark(
                        x: .value("Time", $0.x),
                        y: .value("value", $0.y)
                    )
                    .foregroundStyle(by: .value("key", key))
                }
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
                AxisGridLine()
                    .foregroundStyle(.clear)
                if UIDevice.current.orientation == .landscapeRight {
                    AxisValueLabel(horizontalSpacing: 5.0)
                }
            }
        }
        .chartXScale(domain: vm.xRange)
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
