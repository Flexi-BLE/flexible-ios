//
//  MainTabView.swift
//  ae
//
//  Created by blaine on 4/13/22.
//

import SwiftUI
import FlexiBLE

struct MainTabView: View {
    @EnvironmentObject var profile: FlexiBLEProfile
    private var remoteDataStore = InfluxDBConnection()
    
    var body: some View {
        TabView {
            DevicesView()
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
                    Text("Settings")
                }
        }
        .onAppear() {
            remoteDataStore.set(profile: profile)
        }
        .environmentObject(remoteDataStore)
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
