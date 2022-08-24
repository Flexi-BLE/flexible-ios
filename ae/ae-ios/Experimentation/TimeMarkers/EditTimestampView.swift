//
//  NewEditTimestampView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/3/22.
//

import SwiftUI
import aeble

struct EditTimestampView: View {
    @StateObject var vm: TimestampViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            Section(header: Text("Edit Timemarker")) {
                TextField("Name", text: $vm.newName)
//                if #available(iOS 16.0, *) {
//                    TextField("Description", text: $vm.description,  axis: .vertical)
//                        .lineLimit(4...10)
//                } else {
                TextField("Description", text: $vm.newDescription)
//                }
                
                Button("Confirm Edit") {
                    Task {
                        await self.vm.updateTimeMarkerDetails()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct NewEditTimestampView_Previews: PreviewProvider {
    static var previews: some View {
        EditTimestampView(
            vm: TimestampViewModel(timestamp: Timestamp.dummy())
        )
    }
}
