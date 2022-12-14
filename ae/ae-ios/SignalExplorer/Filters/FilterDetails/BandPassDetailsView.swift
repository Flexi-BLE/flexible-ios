//
//  BandPassDetailsView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 12/14/22.
//

import SwiftUI
import flexiBLE_signal

struct BandPassDetailsView: View {
    var timeSeries: TimeSeries<Float>
    var filter: BandPassFilter
    var update: (()->())?
    
    @State private var cutoffFreqLow: Float = 0.0
    @State private var cutoffFreqLowString = String(0.0)
    @State private var transitionFreqLow: Float = 0.0
    @State private var transitionFreqLowString = String(0.0)
    
    @State private var cutoffFreqHigh: Float = 0.0
    @State private var cutoffFreqHighString = String(0.0)
    @State private var transitionFreqHigh: Float = 0.0
    @State private var transitionFreqHighString = String(0.0)
    
    private var nyquistFreq: Float
    private var maxCutoff: Float {
        return nyquistFreq / 10
    }
    
    private var step: Float {
        if nyquistFreq >= 100 {
            return 1.0
        } else if nyquistFreq >= 50 {
            return 0.5
        } else {
            return 0.1
        }
    }
    
    init(timeSeries: TimeSeries<Float>, filter: BandPassFilter, onUpdate: (()->())?) {
        self.timeSeries = timeSeries
        self.filter = filter
        self.update = onUpdate
        
        self.cutoffFreqLow = filter.cutoffFrequencyLow
        self.cutoffFreqLowString = String(filter.cutoffFrequencyLow)
        self.transitionFreqLow = filter.transitionFrequencyLow
        self.transitionFreqLowString = String(filter.transitionFrequencyLow)
        
        self.cutoffFreqHigh = filter.cutoffFrequencyHigh
        self.cutoffFreqHighString = String(filter.cutoffFrequencyHigh)
        self.transitionFreqHigh = filter.transitionFrequencyHigh
        self.transitionFreqHighString = String(filter.transitionFrequencyHigh)
        
        self.nyquistFreq = Float(timeSeries.nyquistFrequencyHz())
        
        filter.frequency = Float(timeSeries.frequencyHz())
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                HStack {
                    Text("Low Cutoff Frequency")
                        .font(.body.bold())
                    TextField("Low Cutoff Frequency", text: $cutoffFreqLowString)
                        .onSubmit {
                            guard let value = Float(cutoffFreqLowString),
                                  value < maxCutoff, value > 0 else {
                                cutoffFreqLowString = String(cutoffFreqLow)
                                return
                            }
                            cutoffFreqLow = value
                        }
                        .labelsHidden()
                }
                
                Slider(value: $cutoffFreqLow, in: step...maxCutoff) { editing in
                    guard !editing else { return }
                    cutoffFreqLowString = String(cutoffFreqLow)
                    withAnimation {
                        filter.cutoffFrequencyLow = cutoffFreqLow
                        update?()
                    }
                }
            }
            
            Group {
                HStack {
                    Text("Low Transition Frequency")
                        .font(.body.bold())
                    TextField("Low Transition Frequency", text: $transitionFreqLowString)
                        .onSubmit {
                            guard let value = Float(transitionFreqLowString),
                                  value < maxCutoff/2.0, value > 0 else {
                                transitionFreqLowString = String(transitionFreqLow)
                                return
                            }
                            transitionFreqLow = value
                        }
                        .labelsHidden()
                }
                
                Slider(value: $transitionFreqLow, in: step...maxCutoff/2.0) { editing in
                    guard !editing else { return }
                    transitionFreqLowString = String(transitionFreqLow)
                    withAnimation {
                        filter.transitionFrequencyLow = transitionFreqLow
                        update?()
                    }
                }
            }
            
            Group {
                HStack {
                    Text("High Cutoff Frequency")
                        .font(.body.bold())
                    TextField("High Cutoff Frequency", text: $cutoffFreqHighString)
                        .onSubmit {
                            guard let value = Float(cutoffFreqHighString),
                                  value < maxCutoff, value > 0 else {
                                cutoffFreqHighString = String(cutoffFreqHigh)
                                return
                            }
                            cutoffFreqHigh = value
                        }
                        .labelsHidden()
                }
                
                Slider(value: $cutoffFreqHigh, in: step...maxCutoff) { editing in
                    guard !editing else { return }
                    cutoffFreqHighString = String(cutoffFreqHigh)
                    withAnimation {
                        filter.cutoffFrequencyHigh = cutoffFreqHigh
                        update?()
                    }
                }
            }
            
            Group {
                HStack {
                    Text("High Transition Frequency")
                        .font(.body.bold())
                    TextField("High Transition Frequency", text: $transitionFreqHighString)
                        .onSubmit {
                            guard let value = Float(transitionFreqHighString),
                                  value < maxCutoff/2.0, value > 0 else {
                                transitionFreqHighString = String(transitionFreqHigh)
                                return
                            }
                            transitionFreqHigh = value
                        }
                        .labelsHidden()
                }
                
                Slider(value: $transitionFreqHigh, in: step...maxCutoff/2.0) { editing in
                    guard !editing else { return }
                    transitionFreqHighString = String(transitionFreqHigh)
                    withAnimation {
                        filter.transitionFrequencyHigh = transitionFreqHigh
                        update?()
                    }
                }
            }
        }
    }
}

struct BandPassDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BandPassDetailsView(
            timeSeries: TimeSeries<Float>(persistence: 0),
            filter: BandPassFilter(
                frequency: 100,
                cutoffFrequencyHigh: 10,
                transitionFrequencyHigh: 1,
                cutoffFrequencyLow: 90,
                transitionFrequencyLow: 1.0
            ),
            onUpdate: nil
        )
    }
}
