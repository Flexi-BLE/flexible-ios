//
//  SignalExplorerView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 11/18/22.
//

import SwiftUI
import Charts
import flexiBLE_signal
import Accelerate
struct SignalExplorerView: View {
    @StateObject var model = SignalExplorerModel()
    
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Simulated Signal")
                .font(.callout)
                .foregroundStyle(.secondary)
            Text("Aggregate Sin Wave")
                .font(.title2.bold())
            
            TimeFreqChartView(
                model: model
            )
            SignalExplorerFilterList(model: self.model)
        }
        .padding()
        .navigationBarTitle("Signal Explorer", displayMode: .inline)
    }
}

struct SignalExplorerView_Previews: PreviewProvider {
    static var previews: some View {
        SignalExplorerView()
    }
}
