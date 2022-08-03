//
//  EditTimeMarkerView.swift
//  ntrain-exthub (iOS)
//
//  Created by Blaine Rothrock on 2/24/22.
//

import SwiftUI

struct EditTimeMarkerView: View {
    @StateObject var vm: TimeMarkerViewModel
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
                        await self.vm.updateTimeMarkerDetails(withName: vm.name,withDescription:vm.description,forID:vm.id)
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct EditTimeMarkerView_Previews: PreviewProvider {
    static var previews: some View {
        EditTimeMarkerView(vm: TimeMarkerViewModel(id: nil, name: "Sample Name", description: "Sample Description", experimentID: nil, datetime: Date.now))
    }
}
