//
//  ChartAxisAdjustmentPanel.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 10/13/22.
//

import SwiftUI

struct ChartYAxisAdjustmentPanel: View {
    var chartParams: ChartParameters
    
    @State var yAxisMin: Double = 0.0
    @State var yAxisMax: Double = 100.0
    
    init(chartParams: ChartParameters) {
        self.chartParams = chartParams
        self.yAxisMin = chartParams.yMin
        self.yAxisMax = chartParams.yMax
    }
    
    var body: some View {
        VStack {
            Text("X Axis Range")
                .font(.title2)
                .foregroundColor(.black)
                .padding()
            HStack {
                Text(String(format: "%.2f", yAxisMin)).font(.body)
                Spacer()
                Text(String(format: "%.2f", yAxisMax)).font(.body).bold()
                Spacer()
                Text(String(format: "%.2f", chartParams.adjustableYMax)).font(.body)
            }
            Slider(value: $yAxisMax, in: yAxisMin...chartParams.adjustableYMax) { value in
                self.chartParams.yMax = self.yAxisMax
            }
            HStack {
                Text(String(format: "%.2f", chartParams.adjustableYMin)).font(.body)
                Spacer()
                Text(String(format: "%.2f", yAxisMin)).font(.body).bold()
                Spacer()
                Text(String(format: "%.2f", yAxisMax)).font(.body)
            }
            Slider(value: $yAxisMin, in: chartParams.adjustableYMin...yAxisMax) { value in
                self.chartParams.yMin = self.yAxisMin
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
