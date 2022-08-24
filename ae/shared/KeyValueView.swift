//
//  KeyValueView.swift
//  ntrain-exthub
//
//  Created by blaine on 3/1/22.
//

import SwiftUI

struct KeyValueView: View {
    let key: String
    let value: String?
    
    var body: some View {
        HStack {
            Text("\(key):").bold()
            Spacer()
            Text(value ?? "--none--")
        }
    }
}

struct KeyValueView_Previews: PreviewProvider {
    static var previews: some View {
        KeyValueView(key: "key", value: "value")
    }
}
