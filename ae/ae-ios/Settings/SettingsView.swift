//
//  SharedSettingsView.swift
//  ntrain-exthub
//
//  Created by Blaine Rothrock on 1/11/22.
//

import SwiftUI
import UIKit
import Foundation
import Combine
import FlexiBLE
import UniformTypeIdentifiers

struct SettingsView: View {
    
//    @State private var isPresentingPurgeAllConfirm: Bool = false
//    @State private var isPresentingPurgeUploadConfirm: Bool = false
//    @State private var isPresentingConnectionWarning: Bool = false
    @Environment(\.openURL) private var openURL
    
    @EnvironmentObject var flexiBLE: FlexiBLE
    @State private var isPresentingShare: Bool = false
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
                    
#if targetEnvironment(macCatalyst)
                    Button("Copy App Data Path") {
                        UIPasteboard.general.string = flexiBLE.appDataPath.absoluteString
                    }
#else
                    Link("Open FlexiBLE's app data in Files", destination: flexiBLE.appDataPath)
                        .environment(\.openURL, OpenURLAction { url in

                            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
                            components?.scheme = "shareddocuments"

                            print("Open \(components!.url!)")
                            openURL(components!.url!) { accepted in
                                print(accepted ? "Success" : "Failure")
                            }
                            return .handled
                        })
                    
#endif

                    
                    NavigationLink(
                        destination: {
                            UploadDataInfluxDBView()
                                .navigationBarTitleDisplayMode(.inline)
                                .navigationBarTitle("Remote InfluxDB Database")
                        },
                        label: {
                            Text("Remote InfluxDB Database")
                        }
                    )
                    
                    NavigationLink(
                        destination: {
                            UploadRecordsView(vm: UploadRecordsViewModel(profile: flexiBLE.profile!, dataStream: nil))
                                .navigationBarTitleDisplayMode(.inline)
                                .navigationBarTitle("Upload Records")
                        },
                        label: {
                            Text("View Upload Records")
                        }
                    )
                }
                
                Section(header: Text("⚠️ Danger Zone")) {
                    
                    
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
