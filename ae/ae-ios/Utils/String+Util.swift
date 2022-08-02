//
//  String+Util.swift
//  ae-ios
//
//  Created by Nikhil Khandelwal on 8/2/22.
//

import Foundation

extension String {
    func trunc(length: Int, trailing: String = "…") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
      }
}
