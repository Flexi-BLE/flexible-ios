//
//  CenteredView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 2/21/23.
//

import SwiftUI

struct CenteredView<V: View>: View {

    var content: V

    init(_ content: V) { self.content = content }

    var body: some View {
        HStack {
            Spacer()
            content
            Spacer()
        }
    }
}
