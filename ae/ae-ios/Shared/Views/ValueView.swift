//
//  ValueView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 2/21/23.
//

import SwiftUI

struct ValueView: View {
    var value: Int
    var text: String
    
    
    var body: some View {
        VStack {
            CenteredView(Text("\(value)").font(.title3))
            CenteredView(Text(text).font(.body))
        }
    }
}

struct CircleIndication_Previews: PreviewProvider {
    static var previews: some View {
        ValueView(value: 12, text: "found")
    }
}
