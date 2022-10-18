//
//  ChartAxisAdjustmentPanel.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 10/13/22.
//

import SwiftUI

struct ChartYAxisAdjustmentPanel: View {
    var chartParams: ChartParameters
    
    @State var yAxisMin: Double
    @State var yAxisMax: Double
    @State var shouldAutoScale: Bool
    
    init(chartParams: ChartParameters) {
        self.chartParams = chartParams
        self.yAxisMin = chartParams.yMin
        self.yAxisMax = chartParams.yMax
        self.shouldAutoScale = chartParams.shouldAutoScale
    }
    
    var body: some View {
        VStack {
            Text("Y Axis Range")
                .font(.title2)
                .foregroundColor(.black)
                .padding()
            HStack {
                Text("Auto Scale:").bold()
                Spacer()
                Toggle("", isOn: $shouldAutoScale)
                    .labelsHidden()
                    .onChange(of: shouldAutoScale) { newValue in
                        chartParams.shouldAutoScale = newValue
                    }
            }
            HStack {
                Text("Min:").bold()
                Spacer()
                TextField("", value: $yAxisMin, formatter: NumberFormatter())
                    .labelsHidden()
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .disabled(shouldAutoScale)
                    .frame(minWidth: 50, maxWidth: 150)
                    .onChange(of: yAxisMin) { newValue in
                        if newValue < chartParams.yMax {
                            chartParams.yMin = newValue
                        } else {
                            yAxisMin = chartParams.yMin
                        }
                    }
            }
            
            HStack {
                Text("Max:").bold()
                Spacer()
                TextField("", value: $yAxisMax, formatter: NumberFormatter())
                    .labelsHidden()
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .disabled(shouldAutoScale)
                    .frame(minWidth: 50, maxWidth: 150)
                    .onChange(of: yAxisMax) { newValue in
                        if newValue > chartParams.yMin {
                            chartParams.yMax = newValue
                        } else {
                            yAxisMax = chartParams.yMax
                        }
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

struct ChartAxisAdjustmentPanel_Previews: PreviewProvider {
    static var previews: some View {
        ChartYAxisAdjustmentPanel(chartParams: ChartParameters())
    }
}
