//
//  MarkTime.swift
//  ntrain-exthub (iOS)
//
//  Created by Blaine Rothrock on 2/24/22.
//

import SwiftUI

struct MarkTime: View {
    @StateObject var vm: MarkTimeViewModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Form {
            Section(header: Text("Edit Timemarker")) {
                TextField("Name", text: $vm.name)
                if #available(iOS 16.0, *) {
                    TextField("Description", text: $vm.description,  axis: .vertical)
                        .lineLimit(4...10)
                } else {
                    TextField("Description", text: $vm.description)
                }
                
                Button("Confirm Edit") {
                    Task {
//                        await vm.markTime(name: name, description: description)
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct MarkTime_Previews: PreviewProvider {
    static var previews: some View {
        MarkTime(vm: MarkTimeViewModel(id: nil, name: "Sample Name", description: "Sample Description", experimentID: nil, datetime: Date.now))
    }
}
