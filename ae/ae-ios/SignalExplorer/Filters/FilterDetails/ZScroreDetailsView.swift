//
//  ZScroreDetailsView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 12/14/22.
//

import SwiftUI
import flexiBLE_signal

struct ZScroreDetailsView: View {
    
    var filter: ZScoreFilter
    
    private var stdString: String {
        if let std = filter.std as? Float {
            return "\(std)"
        }
        return "???"
    }
    
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
            KeyValueView(key: "Standard Deviation", value: stdString)
        }
    }
}

struct NoEditFilterEditView_Previews: PreviewProvider {
    static var previews: some View {
        ZScroreDetailsView(filter: ZScoreFilter())
    }
}
