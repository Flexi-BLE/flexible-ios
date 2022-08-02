//
//  ExperimentListCellView.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 8/2/22.
//

import SwiftUI

struct ExperimentListCellView: View {
    @ObservedObject var vm: ExperimentViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack(spacing: 19) {
                VStack(alignment: .leading, spacing: 7) {
                    Text(vm.name)
                        .font(.headline)
                    Text(vm.description ?? "--")
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                Spacer()
                switch vm.isActive {
                case true:
                    Image(systemName: "checklist.unchecked")
                        .font(.system(size: 25))
                case false:
                    Image(systemName: "checklist.checked")
                        .font(.system(size: 25))
                }
            }
            Text(getExperimentDisplayDate(start:vm.startDate, end:vm.endDate))
                .font(.subheadline)
        }
        .padding()
    }
    
    
    func getExperimentDisplayDate(start: Date, end: Date?) -> String {
        guard let end = end else {
            return "\(start.getShortDate())"
        }
        return "\(start.getShortDate())".appending(" - \(end.getShortDate())")
    }
}

struct ExperimentListCellView_Previews: PreviewProvider {
    static var previews: some View {
        ExperimentListCellView(vm: ExperimentViewModel(
            id: 1, name: "Heart rate - ALT",
            description: "To measure heart rate while running uphill and capturing other data points and sensor data.",
            start: Date(),
            end: nil,
            active: false)
        )
    }
}
