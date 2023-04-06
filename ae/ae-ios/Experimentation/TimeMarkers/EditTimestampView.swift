//
//  NewEditTimestampView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/3/22.
//

import SwiftUI
import FlexiBLE

struct EditTimestampView: View {
    @StateObject var vm: TimestampViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            Section(header: Text("Edit Timemarker")) {
                TextField("Name", text: $vm.newName)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                TextField("Description", text: $vm.newDescription)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                Button("Save") {
                    self.vm.updateTimeMarkerDetails()
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct NewEditTimestampView_Previews: PreviewProvider {
    static var previews: some View {
        EditTimestampView(
            vm: TimestampViewModel(timestamp: FXBTimestamp.dummy())
        )
    }
}
