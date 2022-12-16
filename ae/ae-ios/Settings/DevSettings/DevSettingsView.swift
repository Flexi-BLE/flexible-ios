//
//  DevelopmentalSettingsView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 11/21/22.
//

import SwiftUI

struct DevSettingsView: View {
    var body: some View {
        List {
            Section {
                DataStreamParamUpdateDelayView()
            }
            Section {
                LiveUploadDevView()
            }
        }
        .navigationTitle("Dev Settings")
    }
}

struct DevelopmentalSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        DevSettingsView()
    }
}
