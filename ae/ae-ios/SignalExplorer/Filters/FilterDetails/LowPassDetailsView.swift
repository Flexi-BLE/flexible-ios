//
//  LowPassFilterDetailsView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 12/14/22.
//

import SwiftUI
import flexiBLE_signal

struct LowPassDetailsView: View {
    var timeSeries: TimeSeries<Float>
    var filter: LowPassFilter
    var update: (()->())?
    
    @State private var cutoffFreq: Float = 0.0
    @State private var cutoffFreqString = String(0.0)
    @State private var transitionFreq: Float = 0.0
    @State private var transitionFreqString = String(0.0)
    
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
    
    init(timeSeries: TimeSeries<Float>, filter: LowPassFilter, onUpdate: (()->())?) {
        self.timeSeries = timeSeries
        self.filter = filter
        self.update = onUpdate
        
        self.cutoffFreq = filter.cutoffFrequency
        self.cutoffFreqString = String(filter.cutoffFrequency)
        self.transitionFreq = filter.transitionFrequency
        self.transitionFreqString = String(filter.transitionFrequency)
        
        self.nyquistFreq = Float(timeSeries.nyquistFrequencyHz())
        
        filter.frequency = Float(timeSeries.frequencyHz())
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                HStack {
                    Text("Cutoff Frequency")
                        .font(.body.bold())
                    TextField("Cutoff Frequency", text: $cutoffFreqString)
                        .onSubmit {
                            guard let value = Float(cutoffFreqString),
                                  value < maxCutoff, value > 0 else {
                                cutoffFreqString = String(cutoffFreq)
                                return
                            }
                            cutoffFreq = value
                        }
                        .labelsHidden()
                }
                
                Slider(value: $cutoffFreq, in: step...maxCutoff) { editing in
                    guard !editing else { return }
                    cutoffFreqString = String(cutoffFreq)
                    withAnimation {
                        filter.cutoffFrequency = cutoffFreq
                        update?()
                    }
                }
            }
            
            Group {
                HStack {
                    Text("Transition Frequency")
                        .font(.body.bold())
                    TextField("Transition Frequency", text: $transitionFreqString)
                        .onSubmit {
                            guard let value = Float(transitionFreqString),
                                  value < maxCutoff/2.0, value > 0 else {
                                transitionFreqString = String(transitionFreq)
                                return
                            }
                            transitionFreq = value
                        }
                        .labelsHidden()
                }
                
                Slider(value: $transitionFreq, in: step...maxCutoff/2.0) { editing in
                    guard !editing else { return }
                    transitionFreqString = String(transitionFreq)
                    withAnimation {
                        filter.transitionFrequency = transitionFreq
                        update?()
                    }
                }
            }
        }
    }
}

struct LowPassFilterDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        LowPassDetailsView(
            timeSeries: TimeSeries<Float>(persistence: 0),
            filter: LowPassFilter(frequency: 100, cutoffFrequency: 10, transitionFrequency: 10),
            onUpdate: nil
        )
    }
}
