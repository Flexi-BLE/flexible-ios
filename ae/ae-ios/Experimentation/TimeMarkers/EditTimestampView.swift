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
                TextField("Description", text: $vm.newDescription)
                
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
