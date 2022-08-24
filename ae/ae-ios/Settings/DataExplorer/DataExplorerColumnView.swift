//
//  SwiftUIView.swift
//  ntrain-exthub (iOS)
//
//  Created by blaine on 2/28/22.
//

import SwiftUI
import aeble

struct SwiftUIView: View {
    var row: GenericRow
    
    var body: some View {
        VStack {
            ForEach(0..<row.columns.count) { i in
                KeyValueView(
                    key: row.metadata[i].name,
                    value: String(describing: row.columns[i].value)
                )
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView(row: GenericRow.dummy())
    }
}
