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
//        let pinchGesture = MagnificationGesture()
//            .onChanged { amount in
//                vm.updateRange(amount: amount)
//            }
//            .onEnded { amount in
//                vm.updateRange(amount: amount, end: true)
//            }
        
//        let dragGesture = DragGesture()
//            .onChanged { value in
//                print("ZOOM: drag: \(value.translation) (\(value.location)")
//            }
//
//        let zoomGesture = pinchGesture.simultaneously(with: dragGesture)
        
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
//                    if UIDevice.current.orientation == .landscapeRight {
                        AxisValueLabel()
//                    }
                }
            }
            .chartXScale(domain: vm.chartParameters.xRange)
            .chartYScale(domain: vm.chartParameters.yRange)
            .clipped()
            
            ChartControls(vm: vm)
        }
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
