//
//  ExperimentMapView.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 8/3/22.
//

import SwiftUI
import MapKit
import FlexiBLE

struct ExperimentMapView: View {
    @StateObject var vm: ExperimentMapViewModel
    
    var body: some View {
        Map(coordinateRegion: $vm.region, annotationItems: vm.points()) { point in
            MapAnnotation(coordinate: point.location) {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 3.0, height: 3.0)
            }
        }.allowsHitTesting(false)
    }
}

struct ExperimentMapView_Previews: PreviewProvider {
    static var previews: some View {
        ExperimentMapView(
            vm: ExperimentMapViewModel(
                profile: FlexiBLEProfile(
                    name: "test",
                    spec: FXBSpec.mock
                ),
                experiment: FXBExperiment.dummyActive()
            )
        )
    }
}
