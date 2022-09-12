//
//  UploadDataInfluxDBView.swift
//  Flexi-BLE
//
//  Created by blaine on 9/1/22.
//

import SwiftUI

struct UploadDataInfluxDBView: View {
    @StateObject var vm: UploadDataInfluxDBViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                VStack(alignment: .leading) {
                    Text("Url")
                        .font(.callout)
                        .bold()
                    TextField("Url", text: $vm.url, prompt: Text("https://mydb.xyz"))
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                }
            
                VStack(alignment: .leading) {
                    Text("Port")
                        .font(.callout)
                        .bold()
                    TextField("Port", text: $vm.port, prompt: Text("8086"))
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                }
            
                VStack(alignment: .leading) {
                    Text("Organization")
                        .font(.callout)
                        .bold()
                    TextField("Organization", text: $vm.org, prompt: Text("flexiBLE"))
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                }
                
                VStack(alignment: .leading) {
                    Text("Bucket")
                        .font(.callout)
                        .bold()
                    TextField("Bucket", text: $vm.bucket, prompt: Text("mySensorData"))
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                }
                
                VStack(alignment: .leading) {
                    Text("Token")
                        .font(.callout)
                        .bold()
                    TextField("Token", text: $vm.token, prompt: Text("abcdef1234567890"))
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                }
            }.padding().task {
                vm.validate()
            }
                
//          TextField("Record Batch Size", text: $vm.batchSize, prompt: Text("1000"))
        }
    }
}

struct UploadDataInfluxDBView_Previews: PreviewProvider {
    static var previews: some View {
        UploadDataInfluxDBView(vm: UploadDataInfluxDBViewModel())
    }
}

