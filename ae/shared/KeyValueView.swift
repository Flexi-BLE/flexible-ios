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
            Text("\(key):")
                .font(.body)
                .bold()
            Spacer()
            Text(value ?? "--none--")
                .font(.body)
        }
    }
}

struct KeyValueView_Previews: PreviewProvider {
    static var previews: some View {
        KeyValueView(key: "key", value: "value")
    }
}

//headingFont: .custom("AlegreyaSans-Bold", size: 28),
//titleFont: .custom("AlegreyaSans-Bold", size: 17),
//sectionTitleFont: .custom("AlegreyaSans-Medium", fixedSize: 20),
//subheadingFont: .custom("AlegreyaSans-Regular", size: 14),
//bodyFont: .custom("AlegreyaSans-Regular", size: 16),
//numericalFont: .custom("Abel-Regular", size: 14)
//headingFont: .custom("Arvo-Bold", size: 28),
//titleFont: .custom("Arvo-Bold", size: 17),
//subheadingFont: .custom("Arvo", size: 15),
//bodyFont: .custom("Ubuntu-Regular", size: 15),
//numericalFont: .custom("Ubuntu-Bold", size: 18)
