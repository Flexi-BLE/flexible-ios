//
//  AlertInfo.swift
//  Flexi-BLE
//
//  Created by blaine on 10/17/22.
//

import Foundation
import SwiftUI

struct AlertInfo: Identifiable {
    let id: UUID = UUID()
    let title: String
    let message: String
    
    let primaryButton: Alert.Button
    let secondaryButton: Alert.Button?
    
    var alert: Alert {
        if let secondaryButton = self.secondaryButton {
            return Alert(
                title: Text(self.title),
                message: Text(self.message),
                primaryButton: self.primaryButton,
                secondaryButton: secondaryButton
            )
        } else {
            return Alert(
                title: Text(self.title),
                message: Text(self.message),
                dismissButton: self.primaryButton
            )
        }
    }
}
