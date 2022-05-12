//
//  String.swift
//  ae
//
//  Created by blaine on 4/26/22.
//

import Foundation

extension String: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}
