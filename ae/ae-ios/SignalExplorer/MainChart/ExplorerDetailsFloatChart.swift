//
//  ExplorerDetailsFrequencyChart.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 11/18/22.
//

import SwiftUI
import Charts
import flexiBLE_signal
import Accelerate

struct ExplorerDetailsFloatChart: View {
    
    private struct Data: Identifiable {
        let name: String
        let signal: [SignalExplorerModel.ChartDataPoint]
        var id: String { name }
    }
    
    private var data: [Data] = []
    private var xLabel: String
    private var yLabel: String
    
    init(
        signal: [SignalExplorerModel.ChartDataPoint],
        compareSignal: [SignalExplorerModel.ChartDataPoint]?,
        signalName: String,
        compareSignalName: String?,
        xLabel: String,
        yLabel: String
    ) {
        data.append(Data(name: signalName, signal: signal))
        if let cs = compareSignal, let name = compareSignalName {
            data.append(Data(name: name, signal: cs))
        }
        
        self.xLabel = xLabel
        self.yLabel = yLabel
    }
    
    var body: some View {
        Chart {
            ForEach(data) { series in
                ForEach(series.signal, id: \.x) { element in
                    LineMark(
                        x: .value(xLabel, element.x),
                        y: .value(yLabel, element.y)
                    )
                }
                .foregroundStyle(by: .value("Signal", series.name))
//                .symbol(by: .value("Signal", series.name))
            }
            .interpolationMethod(.catmullRom)
        }
        .chartLegend(.hidden)
    }
}

//struct ExplorerDetailsFrequencyChart_Previews: PreviewProvider {
//    static var previews: some View {
//        ExplorerDetailsFrequencyChart(model: SignalExplorerModel())
//    }
//}
