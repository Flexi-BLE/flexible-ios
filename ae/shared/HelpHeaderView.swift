//
//  HelpHeaderView.swift
//  ae
//
//  Created by blaine on 4/29/22.
//

import SwiftUI

struct HelpHeaderView: View {
    let title: String
    let helpText: String
    
    @State private var popover = false
    
    var body: some View {
        HStack {
            Text(title)
                .font(.largeTitle)
            Spacer()
            Button(action: { popover = true }) {
                Image(systemName: "info.circle")
                    .font(Font.system(.title2))
            }.fullScreenCover(isPresented: $popover) {
                HelpView(title: title, descriptionText: helpText)
            }
        }
        .padding()
        Divider()
    }
}

struct HelpHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HelpHeaderView(title: "Devices", helpText: "help ...")
    }
}
