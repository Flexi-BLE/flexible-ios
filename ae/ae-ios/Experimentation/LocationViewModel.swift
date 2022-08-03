//
//  LocationViewModel.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 8/3/22.
//

import Foundation

struct LocationViewModel {
    public var id: Int64?
    public var latitude: Double
    public var longitude: Double
    public var altitude: Double
    public var horizontalAccuracy: Double
    public var verticalAccuracy: Double
    public var timestamp: Date
    public var createdAt: Date
}
