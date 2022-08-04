//
//  ExperimentMapView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/3/22.
//

import SwiftUI
import MapKit
import aeble

struct ExperimentMapView: View {
    @StateObject var vm: ExperimentMapViewModel
    
    var body: some View {
        Map(coordinateRegion: $vm.region)
    }
}

struct ExperimentMapView_Previews: PreviewProvider {
    static var previews: some View {
        ExperimentMapView(
            vm: ExperimentMapViewModel(
                Experiment.dummyActive()
            )
        )
    }
}
