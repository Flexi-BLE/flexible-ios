//
//  LiveUploadDevView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 12/16/22.
//

import SwiftUI

enum LiveUpload {
    static private var userDefaultsKey: String = "LiveUpload"
    static var globalUploader = LiveUploader()
    
    static func set(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: Self.userDefaultsKey)
        if value { globalUploader.start() }
        else { globalUploader.stop() }
    }
    
    static func get() -> Bool {
        guard let val = UserDefaults
            .standard
            .object(forKey: Self.userDefaultsKey) as? Bool else {
            
            Self.set(false)
            return false
        }
        
        return val
    }
}

struct LiveUploadDevView: View {
    
    @State private var enabled: Bool = LiveUpload.get()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Live Upload")
                    .font(.title3.bold())
                Text("InfluxDB credentiations must be provided in \"Settings->Remote Database\"")
                    .font(.body)
            }
            Toggle(isOn: $enabled, label: { Text("enabled") })
                .labelsHidden()
                .onChange(of: enabled) { newValue in
                    LiveUpload.set(newValue)
                }
        }
    }
}

struct LiveUploadDevView_Previews: PreviewProvider {
    static var previews: some View {
        LiveUploadDevView()
    }
}
