//
//  UploadRecordsView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 2/2/23.
//

import SwiftUI

struct UploadRecordsView: View {
    
    @StateObject var vm: UploadRecordsViewModel
    
    var body: some View {
        if vm.uploadRecords.isEmpty {
            VStack {
                Spacer()
                Text("No Upload Records Found")
                Spacer()
            }
        } else {
            List(vm.uploadRecords, id: \.id) { rec in
                DataUploadRecordCellView(record: rec)
            }
        }
    }
}

struct UploadRecordsView_Previews: PreviewProvider {
    static var previews: some View {
        UploadRecordsView(vm: UploadRecordsViewModel(dataStream: "none"))
    }
}
