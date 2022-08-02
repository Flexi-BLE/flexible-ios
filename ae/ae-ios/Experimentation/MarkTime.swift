//
//  MarkTime.swift
//  ntrain-exthub (iOS)
//
//  Created by Blaine Rothrock on 2/24/22.
//

import SwiftUI

struct MarkTime: View {
//    var vm: ExperimentViewModel
    
    @State var name: String = ""
    @State var description: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            Section(header: Text("Create Timestamp")) {
                TextField("Name", text: $name)
                TextField("Description", text: $description)
                
                Button("Mark") {
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
//        MarkTime(vm: ExperimentViewModel())
        MarkTime()
    }
}
