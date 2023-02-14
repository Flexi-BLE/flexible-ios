//
//  CreateProfileFromURLView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 1/31/23.
//

import SwiftUI
import FlexiBLE

struct CreateProfileFromURLView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var vm: ProfileSelectionViewModel
    
    @State private var newProfileName: String = ""
    @State private var urlString: String = ""
    
    @State private var showQRFinder: Bool = false
    
    var body: some View {
        ScrollView {
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
                    Button {
                        showQRFinder = true
                    } label: {
                        Image(systemName: "qrcode.viewfinder").font(.title2)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .alert("Scan QR Code: Coming Soon.", isPresented: $showQRFinder) {
                        Button("OK", role: .cancel) { }
                    }
                    
                    Spacer()
                    
                    Button {
                        vm.create(name: newProfileName, urlString: urlString, setActive: true)
                        dismiss()
                    } label: {
                        Text("Create")
                    }
                    .buttonStyle(SecondaryButtonStyle())
                    
                }
                
            }
        }
    }
}

struct CreateProfileFromURLView_Previews: PreviewProvider {
    static var previews: some View {
        CreateProfileFromURLView(vm: ProfileSelectionViewModel(flexiBLE: FlexiBLE()))
    }
}
