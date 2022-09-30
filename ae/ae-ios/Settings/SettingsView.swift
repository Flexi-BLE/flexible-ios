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
    
    @State private var isPresentingPurgeAllConfirm: Bool = false
    @State private var isPresentingPurgeUploadConfirm: Bool = false

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
                
                    Button("Share Database") {
                        ShareUtil.share(path: fxb.db.dbPath)
                    }
                }
                
                Section(header: Text("⚠️ Danger Zone")) {
                    Button ("Purge Uploaded Records") {
                        isPresentingPurgeUploadConfirm = true
                    }.confirmationDialog("Are you sure?",
                                         isPresented: $isPresentingPurgeUploadConfirm) {
                        Button("Delete all UPLOADED records?", role: .destructive) {
                            Task { try? await fxb.write.purgeAllUploadedRecords() }
                        }
                    }
                    
                    Button("Purge All Records") {
                        isPresentingPurgeAllConfirm = true
                    }.confirmationDialog("Are you sure?",
                                         isPresented: $isPresentingPurgeAllConfirm) {
                        Button("Delete ALL records?", role: .destructive) {
                            Task { try? await fxb.write.purgeAllRecords() }
                        }
                    }
                    
                    Button("Purge All Local Configurations") {
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
