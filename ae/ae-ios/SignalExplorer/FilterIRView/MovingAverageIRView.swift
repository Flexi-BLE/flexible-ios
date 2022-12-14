//
//  MovingAverageIRView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 11/18/22.
//

import SwiftUI
import flexiBLE_signal
import Accelerate
import Charts

struct MovingAverageIRView: View {
    
    var window: Int
    var data: [(x: Float, y: Float)]
    
    init(window: Int) {
        self.window = window
        var fft = FFT(N: window)
        let signal = [Float](repeating: 1.0/Float(window), count: window)
        let index: [Float] = vDSP.ramp(withInitialValue: 0.0, increment: 1.0, count: window/2)
        fft.forward(signal: signal)
        self.data = zip(index, fft.forwardReal).map { (x: $0, y: $1) }
    }
    
    var body: some View {
        Chart(data, id: \.x) { element in
            LineMark(
                x: .value("X", element.x),
                y: .value("y", element.y)
            )
        }
        .frame(height: 240)
    }
}

struct MovingAverageIRView_Previews: PreviewProvider {
    static var previews: some View {
        MovingAverageIRView(window: 1)
    }
}
