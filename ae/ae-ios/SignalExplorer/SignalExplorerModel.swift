//
//  SignalExplorerModel.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 11/18/22.
//

import SwiftUI
import Combine
import flexiBLE_signal
import Accelerate

@MainActor class SignalExplorerModel: ObservableObject {
    @Published var filters: [FilterDetails] = []
    
    typealias ChartDoubleIndexDataPoint = (x: Double, y: Float)
    typealias ChartTSDataPoint = (x: Date, y: Float)
    typealias ChartDataPoint = (x: Float, y: Float)
    
    var placeholderSignal: CombinationSinWaveGenerator //SinWaveGenerator
    
    init() {
        self.placeholderSignal = CombinationSinWaveGenerator(
            frequencies: [2, 4, 50, 500],
            step: 0.001,
            start: Date.now,
            persistence: 2_000
        )
        self.placeholderSignal.next(2_000)
    }
    
    var originalSignalDate: [ChartTSDataPoint] {
        return zip(placeholderSignal.ts.indexDates(), placeholderSignal.ts.col(at: 0)).map({ ($0, $1) })
    }
    
    var originalSignalDouble: [ChartDoubleIndexDataPoint] {
        return zip(placeholderSignal.ts.index, placeholderSignal.ts.col(at: 0)).map({ ($0, $1) })
    }
    
    var finalSignalDate: [ChartTSDataPoint] {
        let col = filters.compactMap({ $0.isEnabled && $0.dest != nil ? $0.dest! : nil  }).last ?? 0
        return zip(placeholderSignal.ts.indexDates(), placeholderSignal.ts.col(at: col)).map({ ($0, $1) })
    }
    
    var finalSignalDouble: [ChartDoubleIndexDataPoint] {
        let col = filters.compactMap({ $0.isEnabled && $0.dest != nil ? $0.dest! : nil  }).max() ?? 0
        return zip(placeholderSignal.ts.index, placeholderSignal.ts.col(at: col)).map({ ($0, $1) })
    }
    
    func signalDouble(for i: Int) -> [ChartDoubleIndexDataPoint] {
        return zip(placeholderSignal.ts.index, placeholderSignal.ts.col(at: i)).map({ ($0, $1) })
    }
    
    func signalDate(for i: Int) -> [ChartTSDataPoint] {
        return zip(placeholderSignal.ts.indexDates(), placeholderSignal.ts.col(at: i)).map({ ($0, $1) })
    }
    
    func points(for sig: [Float]) -> [ChartDataPoint] {
        let ramp: [Float] = vDSP.ramp(withInitialValue: 0.0, increment: 1.0, count: sig.count)
        return zip(ramp, sig).map({ (x: $0, y: $1) })
    }
    
    func frequencyDomain(of sig: [ChartDoubleIndexDataPoint]) -> [ChartDataPoint] {
        let freqY = FFT.spectralAnalysis(of: sig.map({ $0.y }))
        let freqX: [Float] = vDSP.ramp(withInitialValue: 0.0, increment: 1.0, count: freqY.count)
        return zip(freqX, freqY).map({ (x: $0, y: $1) })
    }
    
    func update() {
        
        // clear previous filtering
        // FIXME: should probably do a diff
        placeholderSignal.ts.clear(rightOf: 0)
        
        let _filters = filters
        filters = []
    
        for (i, f) in _filters.enumerated() {
            placeholderSignal.ts.apply(filter: f.selection, to: i, at: f.dest ?? nil)
            filters.append(f)
        }
    }
    
    func filterAdded(_ t: SignalFilterType) {
        let filter: any SignalFilter
        let freq = Float(placeholderSignal.ts.frequencyHz())
        
        switch t {
        case .none: return
        case .minMaxScaling:
            filter = MinMaxScalingFilter()
        case .demean:
            filter = DemeanFilter()
        case .zscore:
            filter = ZScoreFilter()
        case .movingAverage:
            filter = MovingAverageFilter(window: 2)
        case .lowPass:
            filter = LowPassFilter(
                frequency: freq,
                cutoffFrequency: freq*0.01,
                transitionFrequency: 1.0
            )
        case .highPass:
            filter = HighPassFilter(
                frequency: freq,
                cutoffFrequency: freq*0.01,
                transitionFrequency: 1.0
            )
        case .bandPass:
            filter = BandPassFilter(
                frequency: freq,
                cutoffFrequencyHigh: freq*0.4,
                transitionFrequencyHigh: 1.0,
                cutoffFrequencyLow: freq*0.1,
                transitionFrequencyLow: 1.0
            )
        case .bandReject:
            filter = BandRejectFilter(
                frequency: freq,
                cutoffFrequencyHigh: freq*0.4,
                transitionFrequencyHigh: 1.0,
                cutoffFrequencyLow: freq*0.1,
                transitionFrequencyLow: 1.0
            )
        }
        
        let lastIdx = filters.count > 0 ? filters.last!.dest ?? 0 : 0
        
        filters.append(
            FilterDetails(
                selection: filter,
                isEnabled: true,
                src: lastIdx,
                dest: lastIdx + 1
            )
        )
        update()
    }
    
    func move(from source: IndexSet, to destination: Int) {
        filters.move(fromOffsets: source, toOffset: destination)
        self.update()
    }
    
    func delete(at indexSet: IndexSet) {
        self.filters.remove(atOffsets: indexSet)
        self.update()
    }
    
    private func points(for col: Int) -> [(x: Double, y: Float)] {
        return zip(
            placeholderSignal.ts.index,
            placeholderSignal.ts.col(at: col)
        ).map { (x: $0, y: $1)}
    }
}
