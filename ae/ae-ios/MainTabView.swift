//
//  MainTabView.swift
//  ae
//
//  Created by blaine on 4/13/22.
//

import SwiftUI
import FlexiBLE

struct MainTabView: View {
    @StateObject var locationManager = LocationManager()
    var body: some View {
        TabView {
            DevicesView(vm: FlexiBLESpecViewModel())
                .tabItem{
                    Image(systemName: "memorychip")
                    Text("Devices")
                }
            ExperimentsView()
                .tabItem {
                    Image(systemName: "waveform.path.ecg.rectangle")
                    Text("Experiments")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "ellipsis.circle.fill")
                    Text("More")
                }
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
