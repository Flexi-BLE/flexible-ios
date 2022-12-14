//
//  ExplorerDetailsChart.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 11/18/22.
//

import SwiftUI
import Charts
import flexiBLE_signal

struct ExplorerDetailsTimeChart: View {
    
    private struct Data: Identifiable {
        let name: String
        let signal: [(x: Date, y: Float)]
        var id: String { name }
    }
    
    private var data: [Data] = []
    
    init(rawSignal: [(x: Double, y: Float)], filteredSignal: [(x: Double, y: Float)]?) {
        if let fs = filteredSignal {
            data.append(Data(name: "Filtered", signal: fs.map({ (x: Date(timeIntervalSince1970: $0), y: $1) })))
        }
        data.append(Data(name: "Raw", signal: rawSignal.map({ (x: Date(timeIntervalSince1970: $0), y: $1) })))
    }
    
    
    var body: some View {
        Chart {
            ForEach(data) { series in
                ForEach(series.signal, id: \.x) { element in
                    LineMark(
                        x: .value("time", element.x),
                        y: .value("arb", element.y)
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

struct ExplorerDetailsChart_Previews: PreviewProvider {
    static var previews: some View {
        ExplorerDetailsTimeChart(rawSignal: [], filteredSignal: nil)
    }
}
