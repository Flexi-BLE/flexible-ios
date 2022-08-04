//
//  NewExperimentListCellView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/3/22.
//

import SwiftUI
import aeble

struct ExperimentListCellView: View {
    @StateObject var vm: ExperimentViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack(spacing: 19) {
                VStack(alignment: .leading, spacing: 7) {
                    Text(vm.experiment.name)
                        .font(.headline)
                    Text(vm.experiment.description ?? "--")
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Text(getExperimentDisplayDate(start:vm.experiment.start, end:vm.experiment.end))
                        .font(.subheadline)
                }
                Spacer()
                switch vm.experiment.active {
                case true:
                    Image(systemName: "checklist.unchecked")
                        .font(.system(size: 25))
                case false:
                    Image(systemName: "checklist.checked")
                        .font(.system(size: 25))
                }
            }
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

struct NewExperimentListCellView_Previews: PreviewProvider {
    static var previews: some View {
        ExperimentListCellView(vm: ExperimentViewModel(Experiment.dummyActive()))
    }
}
