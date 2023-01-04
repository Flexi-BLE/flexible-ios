//
//  SimpleBindingTextField.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 1/4/23.
//

import SwiftUI

struct SimpleBindingTextField: View {
    var title: String
    var binding: Binding<String>
    var keyboardType: UIKeyboardType = .default
    var autoCompletion: Bool = true
    var capitaliation: TextInputAutocapitalization? = nil
    
    var body: some View {
        Text(title)
            .font(.callout)
            .bold()
        TextField(title, text: binding)
            .textFieldStyle(.roundedBorder)
            .textInputAutocapitalization(capitaliation)
            .keyboardType(keyboardType)
            .disableAutocorrection(autoCompletion)
    }
}
