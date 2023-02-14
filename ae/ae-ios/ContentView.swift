//
//  ContentView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 2/13/23.
//

import SwiftUI
import FlexiBLE

// THis is the app SwiftUI Entery Point

struct ContentView: View {
    
    @EnvironmentObject var flexiBLE: FlexiBLE
    
    var body: some View {
        if let profile = flexiBLE.profile {
            MainTabView()
                .environmentObject(profile)
        } else {
            CreateProfileView(vm: ProfileSelectionViewModel(flexiBLE: flexiBLE))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
