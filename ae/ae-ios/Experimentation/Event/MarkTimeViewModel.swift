//
//  MarkTimeViewModel.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 8/2/22.
//

import Foundation

@MainActor class MarkTimeViewModel: ObservableObject {
    let id: Int64?
    @Published var name: String
    @Published var description: String
    let experimentID: Int64?
    let datetime: Date

    init(id: Int64?, name: String, description: String, experimentID: Int64?, datetime: Date) {
        self.id = id
        self.name = name
        self.description = description
        self.experimentID = experimentID
        self.datetime = datetime
    }
}
