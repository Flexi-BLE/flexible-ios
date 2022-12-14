//
//  FilterOptions.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 11/19/22.
//

import SwiftUI

struct MovingAverageCompactEditView: View {
    @State var window: Int
    
    var windowProxy: Binding<Float>{
        Binding<Float>(
            get: { return Float(window) },
            set: { window = Int($0) }
        )
    }
    
    var length: Int
    
    var onChange: (Int) -> ()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Window Size")
                .font(.title3)
            Slider(
                value: windowProxy,
                in: 0...Float(Int(length/2)),
                step: 1.0,
                onEditingChanged: onEditingChanged
            )
            TextField(
                "Value",
                value: $window,
                formatter: NumberFormatter(),
                onEditingChanged: onEditingChanged
            )
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }.modifier(AdaptsToSoftwareKeyboard())
    }
    
    func onEditingChanged(editing: Bool) {
        if !editing { onChange(window) }
    }
}

struct LowPassCompactEditView: View {
    @State var fL: Float
    @State var bL: Float
    
    var frequency: Float
    
    var onChange: (Float, Float) -> ()
    
    var body: some View {
        VStack {
            Text("Cut Off Frequency")
                .font(.body)
            Slider(value: $fL, in: 0...(frequency/2)-1, step: 1.0, onEditingChanged: { editing in
                if !editing { onChange(fL, bL) }
            })
            Text("\(fL)Hz")
                .font(.body)
            
            Text("Transition Frequency")
                .font(.body)
            Slider(value: $bL, in: 0...(frequency/2)-1, step: 1.0, onEditingChanged: { editing in
                if !editing { onChange(fL, bL) }
            })
            Text("\(bL)Hz")
                .font(.body)
        }
    }
}
