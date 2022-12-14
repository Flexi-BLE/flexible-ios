//
//  SignalExplorerModel.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 11/18/22.
//

import SwiftUI
import Charts
import flexiBLE_signal
import Accelerate

//enum FilterSelection: String {
//    case none = "None"
//    case minMaxScaling = "Min Max Scaling"
//    case zscore = "Z-Score Normalization"
//    case demean = "Demean"
//    case movingAvgerage = "Moving Average"
//    case lowPass = "Low Pass"
//    case highPass = "High Pass"
//    case bandPass = "Band Pass"
//    case bandReject = "Band Reject"
//
//    var description: String {
//        // TODO:
//        return "Z-score normalization refers to the process of normalizing every value in a dataset such that the mean of all of the values is 0 and the standard deviation is 1."
//    }
//
//    func createTsFilter() -> TimeSeries<Float>.FilterType? {
//        switch self {
//        case .none:
//            return nil
//        case .minMaxScaling:
//            return .minMaxScaling
//        case .zscore:
//            return .zscore
//        case .demean:
//            return .demean
//        case .movingAvgerage:
//            return .movingAverage(window: 100)
//        case .lowPass:
//            return .lowPass(cutoff: 1.0, transition: 1.0)
//        case .highPass:
//            return .highPass(cutoff: 1.0, transition: 1.0)
//        case .bandPass:
//            return .bandPass(cutoffHigh: 1.0, transitionHigh: 1.0, cutoffLow: 1.0, transitionLow: 1.0)
//        case .bandReject:
//            return .bandReject(cutoffHigh: 1.0, transitionHigh: 1.0, cutoffLow: 1.0, transitionLow: 1.0)
//        }
//    }
//}

class FilterSelectionDetails {
    var id: UUID
    var selection: any SignalFilter
    var isEnabled: Bool
    
    var src: Int?=nil
    var dest: Int?=nil
    
    init(selection: any SignalFilter, isEnabled: Bool = true, src: Int? = nil, dest: Int? = nil) {
        self.id = UUID()
        self.selection = selection
        self.isEnabled = isEnabled
        self.src = src
        self.dest = dest
    }
    
    var shortDescription: String {
        switch selection.type {
        default: return "i am filter details"
        }
    }
}

@MainActor class SignalExplorerModel: ObservableObject {
    @Published var filters: [FilterSelectionDetails] = []
    typealias ChartDataPoint = (x: Double, y: Float)
    
    var placeholderSignal: CombinationSinWaveGenerator //SinWaveGenerator
    
    init() {
        self.placeholderSignal = CombinationSinWaveGenerator(
            frequencies: [2, 4, 50, 500],
            step: 0.001,
            start: Date.now,
            persistence: 2_000
        )
        self.placeholderSignal.next(2_000)
//        withAnimation {
//            self.rawSignal = points(for: 0)
//            print()
//        }
    }
    
    func update() {
        
        // clear previous filtering
        // FIXME: should probably do a diff
        placeholderSignal.ts.clear(rightOf: 0)
        
//        guard filters.count > 0 else {
//            self.rawSignal = points(for: 0)
//            self.filteredSignal = nil
//            return
//        }
        
        for (i, f) in self.filters.enumerated() {
            placeholderSignal.ts.apply(filter: f.selection, to: i)
            f.src = i
            f.dest = placeholderSignal.ts.count
            
        }

//        withAnimation {
//            self.rawSignal = points(for: 0)
//            self.filteredSignal = points(for: filters.count)
//        }
    }
    
    func filterAdded(_ t: SignalFilterType) {
        let filter: any SignalFilter
        let freq = Float(placeholderSignal.ts.frequency())
        
        switch t {
        case .none: return
        case .movingAverage:
            filter = MovingAverageFilter(window: 10)
        case .minMaxScaling:
            filter = MinMaxScalingFilter()
        case .demean:
            filter = DemeanFilter()
        case .zscore:
            filter = ZScoreFilter()
        case .lowPass:
            filter = LowPassFilter(
                frequency: freq,
                cutoffFrequency: freq*0.1,
                transitionFrequency: 1.0
            )
        case .highPass:
            filter = LowPassFilter(
                frequency: freq,
                cutoffFrequency: freq*0.9,
                transitionFrequency: 1.0
            )
        case .bandPass:
            filter = BandPassFilter(
                frequency: freq,
                cutoffFrequencyHigh: freq*0.9,
                transitionFrequencyHigh: 1.0,
                cutoffFrequencyLow: freq*0.1,
                transitionFrequencyLow: 1.0
            )
        case .bandReject:
            filter = BandRejectFilter(
                frequency: freq,
                cutoffFrequencyHigh: freq*0.9,
                transitionFrequencyHigh: 1.0,
                cutoffFrequencyLow: freq*0.1,
                transitionFrequencyLow: 1.0
            )
        }
        
        let lastIdx = filters.count > 0 ? filters.last!.dest ?? 0 : 0
        
        filters.append(
            FilterSelectionDetails(
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
