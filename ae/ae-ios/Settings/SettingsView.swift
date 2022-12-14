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
    
//    @State private var isPresentingPurgeAllConfirm: Bool = false
//    @State private var isPresentingPurgeUploadConfirm: Bool = false
//    @State private var isPresentingConnectionWarning: Bool = false
    
    @State private var alertInfo: AlertInfo?
    var connectedDeviceWarningAlert: AlertInfo {
        return AlertInfo(
            title: "Device Connected",
            message: "Dissconnect all device before executing operation.",
            primaryButton: Alert.Button.default(Text("Ok")),
            secondaryButton: nil
        )
    }

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
                        alertInfo = AlertInfo(
                            title: "Are you sure?",
                            message: "This will remove all sensor data that has been uploaded to a remote database. This action is irreversible.",
                            primaryButton: .destructive(Text("Delete")) { Task { try? await fxb.write.purgeAllUploadedRecords() } },
                            secondaryButton: .cancel(Text("Cancel"))
                        )
                    }
                    
                    Button("Purge All Records") {
                        if fxb.conn.fxbConnectedDevices.count > 0 || fxb.conn.connectedRegisteredDevices.count > 0 {
                            alertInfo = connectedDeviceWarningAlert
                        } else {
                            alertInfo = AlertInfo(
                                title: "Are you sure?",
                                message: "This will remove all data in the local database. This action is irreversible.",
                                primaryButton: .destructive(Text("Delete")) {
                                    fxb.write.purgeAllRecords()
                                    Task {
                                        if let spec = fxb.spec {
                                            try? await fxb.setSpec(spec)
                                        }
                                    }
                                },
                                secondaryButton: .cancel(Text("Cancel"))
                            )
                        }
                    }
                    
                    
                    Button("Purge All Local Configurations") {
                        alertInfo = AlertInfo(
                            title: "Are you sure?",
                            message: "This will remove all local configurations, including auto connected devices, graph settings, data stream default parameter overrides, etc. This action is irreversible.",
                            primaryButton: .destructive(Text("Delete")) {
                                Task {
                                    if let id = Bundle.main.bundleIdentifier {
                                        UserDefaults.standard.removePersistentDomain(forName: id)
                                    }
                                }
                            },
                            secondaryButton: .cancel(Text("Cancel"))
                        )
                    }
                }
                
                Section(header: Text("Development")) {
                    
                    NavigationLink(destination: {
                        DevSettingsView()
                    }, label: {
                        Text("Settings")
                    })
                    
                    NavigationLink(
                        destination: SignalExplorerView(),
                        label: {
                            Text("Signal Explorer")
                        }
                    )
                    
                    NavigationLink(
                        destination: TestingEditView(),
                        label: {
                            Text("Test Edit")
                        }
                    )

                }
                
            }
            .alert(item: $alertInfo, content: { $0.alert })
            .navigationBarTitle("Settings")
        }

    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
