//
// Created by Blaine Rothrock on 10/19/22.
//

import Foundation
import FlexiBLE
import flexiBLE_signal
import Combine

/*
    serves as a connector to the TimeSeries Data Type and
    FlexiBLE Sensor Data (Data Streams)
 */
//class DataStreamTimeSeriesBuilder<T: FXBFloatingPoint>: ObservableObject {
//
//    var data = PassthroughSubject<[TimeSeries<T>], Error>()
//
//    private var device: FXBDevice?
//    private var dataStream: FXBDataStream
//    private var observers: Set<AnyCancellable> = []
//
//    init(ds: FXBDataStream, device: FXBDevice? = nil) {
//        self.dataStream = ds
//        self.device = device
//    }
//
//    private func buildFromQuery() -> TimeSeries<T> {
//        // TODO: build a time series from query
//    }
//
//    private func buildLive() -> TimeSeries<T> {
//
//    }
//}
