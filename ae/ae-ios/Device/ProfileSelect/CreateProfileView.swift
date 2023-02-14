//
//  CreateProfileView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 2/13/23.
//

import SwiftUI
import FlexiBLE

struct CreateProfileView: View {
    @StateObject var vm: ProfileSelectionViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Welcome to FlexiBLE").font(.largeTitle)
            Spacer()
            Group {
                if let errorMessage = vm.errorMessage {
                    Text("Error: ").font(.title2).bold()
                    Text(errorMessage)
                    Divider()
                }
            }
            CreateProfileFromURLView(vm: vm)
            Spacer()
        }.padding()
    }
}

struct CreateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CreateProfileView(vm: ProfileSelectionViewModel(flexiBLE: FlexiBLE()))
    }
}
