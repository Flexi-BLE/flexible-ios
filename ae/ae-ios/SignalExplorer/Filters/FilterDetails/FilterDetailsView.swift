//
//  FilterDetailsView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 12/14/22.
//

import SwiftUI
import flexiBLE_signal

struct FilterDetailsView: View {
    @ObservedObject var model: SignalExplorerModel
    var filterDetails: FilterDetails
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Description")
                .font(.title2.bold())
            Text(filterDetails.selection.type.description)
                .font(.body)
                .lineLimit(nil)
            Divider()
            
            switch filterDetails.selection.type {
            case .minMaxScaling:
                MinMaxScalingDetailsView(filter: filterDetails.selection as! MinMaxScalingFilter)
            case .zscore:
                ZScroreDetailsView(filter: filterDetails.selection as! ZScoreFilter)
            case .demean:
                DemeanDetailsView(filter: filterDetails.selection as! DemeanFilter)
            case .movingAverage:
                MovingAverageDetailsView(
                    timeSeries: model.placeholderSignal.ts,
                    filter: filterDetails.selection as! MovingAverageFilter,
                    onUpdate: { model.update() }
                )
            case .lowPass:
                LowPassDetailsView(
                    timeSeries: model.placeholderSignal.ts,
                    filter: filterDetails.selection as! LowPassFilter,
                    onUpdate: { model.update() }
                )
            case .highPass:
                HighPassDetailsView(
                    timeSeries: model.placeholderSignal.ts,
                    filter: filterDetails.selection as! HighPassFilter,
                    onUpdate: { model.update() }
                )
            case .bandPass:
                BandPassDetailsView(
                    timeSeries: model.placeholderSignal.ts,
                    filter: filterDetails.selection as! BandPassFilter,
                    onUpdate: { model.update() }
                )
            default: Text("uh oh.")
            }
        }
    }
}

struct FilterDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        FilterDetailsView(
            model: SignalExplorerModel(),
            filterDetails: FilterDetails(selection: ZScoreFilter())
        )
    }
}
