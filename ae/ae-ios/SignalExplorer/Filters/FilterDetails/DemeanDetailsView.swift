//
//  DemeanDetailsView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 12/14/22.
//

import SwiftUI
import flexiBLE_signal

struct DemeanDetailsView: View {
    var filter: DemeanFilter
    
    private var meanString: String {
        if let std = filter.mean as? Float {
            return "\(std)"
        }
        return "???"
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Before Normalization")
                .font(.title3)
            KeyValueView(key: "Mean", value: meanString)
        }
    }
}

struct DemeanDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DemeanDetailsView(filter: DemeanFilter())
    }
}
