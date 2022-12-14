//
//  FilterEditView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 12/14/22.
//

import Foundation
import SwiftUI
import flexiBLE_signal

struct FilterEditView: View {
    @ObservedObject var model: SignalExplorerModel
    var filter: FilterDetails
    
    var updatedFilter: TimeSeries<Float>.FilterType? = nil
    
    var onClose: ()->()
    var onUpdate: (TimeSeries<Float>.FilterType?)->()
    
    var body: some View {
        ScrollView {
            HStack {
                FilterCompactDetails(filter: filter)
                Spacer()
                Button(
                    action: { onClose() },
                    label: { Image(systemName: "xmark").font(.body) }
                )
            }
            
            TimeFreqChartView(model: model, selectedFilter: filter)
            
            Divider()
            Spacer().frame(height: 45.0)
            
            FilterDetailsView(
                model: model,
                filterDetails: filter
            )
            
            Spacer()
        }
    }
}
