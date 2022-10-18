//
//  DataStreamGraphParameters.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 10/4/22.
//

import Foundation

class DataStreamGraphParameters: Codable {
    var filterSelections: [String:[Int]] = [:]
    var dependentSelections: [String] = []
}
