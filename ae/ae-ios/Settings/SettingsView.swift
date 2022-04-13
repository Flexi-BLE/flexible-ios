//
//  SharedSettingsView.swift
//  ntrain-exthub
//
//  Created by Blaine Rothrock on 1/11/22.
//

import SwiftUI
import Foundation
import Combine
//import aeble

struct SettingsView: View {

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("App Information")) {
                    HStack() {
                        Text("App Version: ").bold()
                        Spacer()
                        Text("\(Bundle.main.os) \(Bundle.main.appVersion) (\(Bundle.main.buildNumber))")
                    }
                }
                
                Section(header: Text("Data Management")) {
                    NavigationLink(
                        destination: AEBLESettingsView(),
                        label: {
                            Text("AEBLE Settings")
                        }
                    )
                    NavigationLink(
                        destination: DataExplorerView(),
                        label: {
                            Text("Data Explorer")
                        }
                    )
                    
                    Button("Share Database") {
                        ShareUtil.share(path: aeble.db.dbPath)
                    }
                }
                
            }
//            .listStyle(GroupedListStyle())
            .navigationBarTitle("Settings")
        }

    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
