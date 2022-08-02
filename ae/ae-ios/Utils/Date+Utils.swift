//
//  Date+Utils.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 8/2/22.
//

import Foundation

extension Date {
    
    func getMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
    
    func getNameOfDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
    
    func getShortDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, YYYY"
        return dateFormatter.string(from: self)
    }
    
    func getDetailedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss"
        return dateFormatter.string(from: self)
    }

}