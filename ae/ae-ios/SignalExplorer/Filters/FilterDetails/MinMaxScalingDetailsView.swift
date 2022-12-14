//
//  MinMaxScalingDetailsView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 12/14/22.
//

import SwiftUI
import flexiBLE_signal

struct MinMaxScalingDetailsView: View {
    var filter: MinMaxScalingFilter
    
    var minString: String {
        if let min = filter.min as? Float {
            return "\(min)"
        }
        return "???"
    }
    
    var maxString: String {
        if let max = filter.max as? Float {
            return "\(max)"
        }
        return "???"
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Before Normalization")
                .font(.title3)
            KeyValueView(key: "Minimum", value: minString)
            KeyValueView(key: "Maximum", value: maxString)
        }
    }
}

struct MinMaxScalingDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MinMaxScalingDetailsView(filter: MinMaxScalingFilter())
    }
}
