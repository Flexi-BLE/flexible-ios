//
//  Path.swift
//  ae
//
//  Created by Blaine Rothrock on 4/27/22.
//

import Foundation
import SwiftUI

extension Path {
    
    static func lineChart(points:[Float], step:CGPoint) -> Path {
        var path = Path()
        if (points.count < 2){
            return path
        }
        let offset = Float(0)
        let p1 = CGPoint(x: 0, y: CGFloat(points[0]-offset)*step.y)
        path.move(to: p1)
        for pointIndex in 1..<points.count {
            let p2 = CGPoint(x: step.x * CGFloat(pointIndex), y: step.y*CGFloat(points[pointIndex]-offset))
            path.addLine(to: p2)
        }
        return path
    }
}
