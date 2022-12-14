//
//  FilterCompactDetails.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 12/14/22.
//

import Foundation
import SwiftUI

struct FilterCompactDetails: View {
    var filter: FilterDetails
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(filter.selection.type.rawValue)")
                    .font(.headline)
//                if let details = filter.details {
//                    Text(details)
//                        .font(.callout).foregroundColor(.gray)
//                }
            }
        }
    }
}
