//
//  DataUploadRecordCellView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 2/2/23.
//

import SwiftUI
import FlexiBLE

struct DataUploadRecordCellView: View {
    
    var record: FXBDataUpload
    
    var uploadPercent: Float {
        (Float(record.uploadCount) / Float(record.expectedUploadCount)) * 100.0
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(record.tableName).font(.title2)
            Text(record.ts.formatted())
            Text("\(record.database) (\(record.APIURL))")
            Text("\(String(format: "%.2f", uploadPercent))% uploaded (\(record.uploadCount.formatted())/\(record.expectedUploadCount.formatted()))")
            Text("\(String(format: "%.2f", record.uploadTimeSeconds)) seconds for \(record.numberOfAPICalls) API calls")
            
            
            if let errorMessage = record.errorMessage {
                Text("Upload Error: \(errorMessage)")
            }
        }
    }
}

struct DataUploadRecordCellView_Previews: PreviewProvider {
    static var previews: some View {
        DataUploadRecordCellView(record: FXBDataUpload.mock())
    }
}
