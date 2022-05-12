//
//  LineView.swift
//  ae
//
//  Created by Blaine Rothrock on 4/27/22.
//

import SwiftUI

struct LineView: View {
    var data: [(Float)]
    @Binding var frame: CGRect
    
    let padding: CGFloat = 30
    
    var stepWidth: CGFloat {
        if data.count < 2 {
            return 0
        }
        return frame.size.width / CGFloat(data.count-1)
    }
    
    var stepHeight: CGFloat {
        var min: Float?
        var max: Float?
        var mean: Float?
        let points = self.data
        if let minPoint = points.min(), let maxPoint = points.max(), minPoint != maxPoint {
            min = minPoint
            max = maxPoint
            mean = Float(self.data.reduce(0, +)) / Float(self.data.count)
        } else {
            return 0
        }
        if let min = min, let max = max, min != max, let mean = mean {
            if (min <= 0){
                return ((frame.size.height-padding) / 2) / CGFloat(mean)
            }else{
                return ((frame.size.height-padding) / 2) / CGFloat(mean)
            }
        }
        
        return 0
    }
    
    var path: Path {
        let points = self.data
        return Path.lineChart(points: points, step: CGPoint(x: stepWidth, y: stepHeight))
    }
    
    var body: some View {
        self.path
            .stroke(Color.green ,style: StrokeStyle(lineWidth: 1, lineJoin: .round))
            .rotationEffect(.degrees(180), anchor: .center)
            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            .drawingGroup()
    }
}

struct LineView_Previews: PreviewProvider {
    static var previews: some View {
        LineView(
            data: [1.0, 2.0, 3.0, 4.0],
            frame: .constant(CGRect(x: 0, y: 0, width: 100, height: 100))
        )
        .previewLayout(.sizeThatFits)
    }
}
