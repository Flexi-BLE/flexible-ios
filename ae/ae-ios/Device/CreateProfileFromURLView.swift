//
//  CreateProfileFromURLView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 1/31/23.
//

import SwiftUI

struct CreateProfileFromURLView: View {
    
    @StateObject var vm: ProfileSelectionViewModel
    
    @State private var newProfileName: String = ""
    @State private var urlString: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Create a new profile")
                .font(.title2)
                .bold()
            
            Spacer().frame(height: 16.0)
            
            Text("Profile Name")
                .font(.callout)
                .bold()
            TextField("", text: $newProfileName)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.default)
                .disableAutocorrection(true)
            
            Text("FlexiBLE Specification URL")
                .font(.callout)
                .bold()
            TextField("", text: $urlString)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .keyboardType(.URL)
                .disableAutocorrection(true)
            
            HStack {
                Spacer()
                FXBButton {
                    vm.create(name: newProfileName, urlString: urlString)
                } content: {
                    Text("Create")
                }
            }

        }
    }
}

struct CreateProfileFromURLView_Previews: PreviewProvider {
    static var previews: some View {
        CreateProfileFromURLView(vm: ProfileSelectionViewModel())
    }
}
