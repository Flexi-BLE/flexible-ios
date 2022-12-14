//
//  LowPassIRView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 11/18/22.
//

import SwiftUI
import Charts
import Accelerate
import flexiBLE_signal

struct LowPassIRView: View {
    
    var cutoff: Float
    var transition: Float
    var data: [(x: Float, y: Float)]
    
    init(frequency: Float, cutoff: Float, transition: Float) {
        self.cutoff = cutoff
        self.transition = transition
        
        let filter = makeLowPassFilter(fS: frequency, fL: cutoff, bL: transition)
        let index: [Float] = vDSP.ramp(withInitialValue: 0.0, increment: 1.0, count: filter.count)
        data = zip(index, filter).map { (x: $0, y: $1) }
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

struct LowPassIRView_Previews: PreviewProvider {
    static var previews: some View {
        LowPassIRView(frequency: 10.0, cutoff: 5.0, transition: 1.0)
    }
}
