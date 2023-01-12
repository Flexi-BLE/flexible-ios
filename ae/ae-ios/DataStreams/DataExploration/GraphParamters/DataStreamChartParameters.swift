//
//  DataStreamGraphParameters.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 10/4/22.
//

import Foundation

class DataStreamChartParameters: Codable {
    var tagSelections: [String: [Int]] = [:]
    var dependentSelections: [String] = []
}
