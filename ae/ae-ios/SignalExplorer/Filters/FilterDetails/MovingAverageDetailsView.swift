//
//  MovingAverageDetailsView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 12/14/22.
//

import SwiftUI
import flexiBLE_signal

struct MovingAverageDetailsView: View {
    var timeSeries: TimeSeries<Float>
    var filter: MovingAverageFilter
    var update: (() -> ())?
    
    @State private var window: Int = 0
    private var windowIntProxy: Binding<Double> {
        Binding<Double>(
            get: { return Double(window) },
            set: { window = Int($0) }
        )
    }
    
    @State private var windowText: String = String(0)
    
    private var min: Double = 2
    private var max: Double { return Double(timeSeries.count / 2) }
    
    init(timeSeries: TimeSeries<Float>, filter: MovingAverageFilter, onUpdate: (()->())?) {
        self.timeSeries = timeSeries
        self.filter = filter
        self.update = onUpdate
        
        window = filter.window
        windowText = String(filter.window)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Window Size:")
                    .font(.body.bold())
                TextField("Window", text: $windowText)
                    .onSubmit {
                        guard let value = Int(windowText),
                              Double(value) <= max,
                              Double(value) >= min else {
                            windowText = String(window)
                            return
                        }
                        
                        window = value
                    }
                    .labelsHidden()
            }
            
            Slider(value: windowIntProxy, in: min...max, step: 1.0) { editing in
                guard !editing else { return }
                windowText = String(window)
                withAnimation {
                    filter.window = window
                    update?()
                }
            }
        }
    }
}

struct MovingAverageDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MovingAverageDetailsView(
            timeSeries: TimeSeries<Float>(persistence: 0),
            filter: MovingAverageFilter(window: 10),
            onUpdate: nil
        )
    }
}
