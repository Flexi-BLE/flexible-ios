//
//  ChartEWMAAdjustmentPanel.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 3/17/23.
//

import SwiftUI

struct ChartEWMAAdjustmentPanel: View {
    var chartParams: ChartParameters
    
    @State var enabled: Bool
    @State var alpha: Double
    
    init(chartParams: ChartParameters) {
        self.chartParams = chartParams
        self.enabled = .init(chartParams.ewmaEnabled)
        self.alpha = .init(chartParams.ewmaAlpha)
    }
    
    var body: some View {
        VStack {
            Text("Exponetnially Weighted Moving Average Filter")
                .font(.title2)
                .foregroundColor(.black)
                .padding()
            HStack {
                Text("Enabled:").bold()
                Spacer()
                Toggle("", isOn: $enabled)
                    .labelsHidden()
                    .onChange(of: enabled) { newValue in
                        chartParams.ewmaEnabled = newValue
                    }
            }
            HStack {
                Text("Alpha:").bold()
                Text("\(alpha.uiReadable())")
                Spacer()
                Slider(
                    value: $alpha,
                    in: 0.0...1.0,
                    step: 0.05,
                    label: { Text("Alpha") },
                    minimumValueLabel: { Text("0") },
                    maximumValueLabel: { Text("1") }
                )
                .labelsHidden()
                .disabled(!enabled)
                .frame(minWidth: 50, maxWidth: 250)
                .onChange(of: alpha) { newValue in
                    chartParams.ewmaAlpha = alpha
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10.0)
                .foregroundColor(.white)
                .shadow(color: .gray, radius: 3, x: -2, y: 2)
        )
    }
}

struct EWMAAdjustmentPanel_Previews: PreviewProvider {
    static var previews: some View {
        ChartEWMAAdjustmentPanel(chartParams: ChartParameters())
    }
}
