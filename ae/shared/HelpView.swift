//
//  HelpView.swift
//  ae
//
//  Created by blaine on 4/29/22.
//

import SwiftUI

struct HelpView: View {
    let title: String
    let descriptionText: String
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .padding()
            Divider()
            ScrollView {
                Text(descriptionText)
                    .fixedSize(horizontal: true, vertical: false)
                    .padding()
            }
            VStack(alignment: .center) {
                Button(
                    action: { dismiss() },
                    label: { Text("Dismiss") }
                ).padding()
            }
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView(title: "cool", descriptionText: "cool...")
    }
}
