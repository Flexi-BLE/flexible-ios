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

struct ExplorerDetailsFrequencyChart: View {
    
    private struct Data: Identifiable {
        let name: String
        let signal: [(x: Float, y: Float)]
        var id: String { name }
    }
    
    private var data: [Data] = []
    
    init(rawSignal: [(x: Double, y: Float)], filteredSignal: [(x: Double, y: Float)]?) {
        
        if let fs = filteredSignal {
            let freqY = FFT.spectralAnalysis(of: fs.map({ $0.y }))
            let freqX = vDSP.ramp(withInitialValue: Float(0.0), increment: 1.0, count: freqY.count)
            data.append(Data(name: "filtered", signal: zip(freqX, freqY).map { (x: $0, y: $1) }))
        }
        
        let freqY = FFT.spectralAnalysis(of: rawSignal.map({ $0.y }))
        let freqX = vDSP.ramp(withInitialValue: Float(0.0), increment: 1.0, count: freqY.count)
        data.append(Data(name: "raw", signal: zip(freqX, freqY).map { (x: $0, y: $1) }))
    }
    
    var body: some View {
        Chart {
            ForEach(data) { series in
                ForEach(series.signal, id: \.x) { element in
                    LineMark(
                        x: .value("Amplitude", element.x),
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

//struct ExplorerDetailsFrequencyChart_Previews: PreviewProvider {
//    static var previews: some View {
//        ExplorerDetailsFrequencyChart(model: SignalExplorerModel())
//    }
//}
