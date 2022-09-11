//
//  SharedSettingsView.swift
//  ntrain-exthub
//
//  Created by Blaine Rothrock on 1/11/22.
//

import SwiftUI
import Foundation
import Combine
//import FlexiBLE

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
                        destination: DataExplorerView(),
                        label: {
                            Text("Data Explorer")
                        }
                    )
                    
                    NavigationLink(
                        destination: {
                            UploadDataView()
                                .navigationBarTitleDisplayMode(.inline)
                                .navigationBarTitle("Remote Database")
                        },
                        label: {
                            Text("Remote Database")
                        }
                    )
                
                    Button ("Purge Uploaded Records") {
                        Task {
                            do {
                                try await fxb.write.purgeAllUploadedRecords()
                            } catch {
                                gLog.error("error purging uploaded records: \(error.localizedDescription)")
                            }
                        }
                    }
                    
                    Button("Purge All Records") {
                        Task {
                            do {
                                try await fxb.write.purgeAllRecords()
                            } catch {
                                gLog.error("error purging database: \(error.localizedDescription)")
                            }
                        }
                    }
                    
                    Button("Purge All Graph Configuration") {
                        Task {
                            if let id = Bundle.main.bundleIdentifier {
                                UserDefaults.standard.removePersistentDomain(forName: id)
                            }
                        }
                    }
                    
                    Button("Share Database") {
                        ShareUtil.share(path: fxb.db.dbPath)
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
