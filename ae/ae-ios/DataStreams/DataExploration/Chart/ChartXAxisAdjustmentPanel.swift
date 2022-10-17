//
//  ChartXAxisAdjustmentPanel.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 10/13/22.
//

import SwiftUI

struct ChartXAxisAdjustmentPanel: View {
    var chartParams: ChartParameters
    
    @State var start: Date = Date.now.addingTimeInterval(25)
    @State var end: Date = Date.now
    @State var liveInterval: TimeInterval = 0
    
    init(chartParams: ChartParameters) {
        self.chartParams = chartParams
    }
    
    var body: some View {
        VStack {
            Text("Y Axis Range")
                .font(.title2)
                .foregroundColor(.black)
                .padding()
            switch chartParams.state {
            case .live:
                VStack {
                    HStack {
                        Text("Time Interval:").bold()
                        Spacer()
                        Text("\(liveInterval.uiReadable(precision: 0)) seconds")
                    }
                    Slider(value: $liveInterval, in: 5...120, step: 5) { value in
                        chartParams.liveInterval = self.liveInterval
                    }
                }
            case .timeboxed, .livePaused, .unspecified:
                HStack {
                    Text("Start Date:").bold()
                    Spacer()
                    DatePicker(
                        "",
                        selection: $start,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .onChange(of: start, perform: {
                        chartParams.start = $0
                    })
                    .datePickerStyle(.compact)
                    .labelsHidden()
                }
                HStack {
                    Text("End Date:").bold()
                    Spacer()
                    DatePicker(
                        "",
                        selection: $end,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .onChange(of: end, perform: {
                        chartParams.end = $0
                    })
                    .datePickerStyle(.compact)
                    .labelsHidden()
                }
            }
            
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10.0)
                .foregroundColor(.white)
                .shadow(color: .gray, radius: 3, x: -2, y: 2)
        )
        .onAppear() {
            self.start = chartParams.start
            self.end = chartParams.end
            self.liveInterval = chartParams.liveInterval
        }
    }
}

struct ChartXAxisAdjustmentPanel_Previews: PreviewProvider {
    static var previews: some View {
        ChartXAxisAdjustmentPanel(chartParams: ChartParameters())
    }
}
