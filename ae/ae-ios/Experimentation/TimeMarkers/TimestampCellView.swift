//
//  NewTimestampCellView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/3/22.
//

import SwiftUI
import FlexiBLE

struct TimestampCellView: View {
    @StateObject var vm: TimestampViewModel
    
    var body: some View {
        NavigationLink(destination: EditTimestampView(vm: vm)) {
            Text(vm.timestamp.name ?? "")
                .foregroundColor(.black)
                .font(.subheadline)
        }
    }
}
