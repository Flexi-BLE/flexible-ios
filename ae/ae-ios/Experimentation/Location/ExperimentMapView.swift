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
        Map(coordinateRegion: $vm.region, annotationItems: vm.points()) { point in
            MapAnnotation(coordinate: point.location) {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 5.0, height: 5.0)
            }
        }.allowsHitTesting(false)
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
