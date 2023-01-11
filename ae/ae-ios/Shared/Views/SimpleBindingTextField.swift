//
//  SimpleBindingTextField.swift
//  ae-ios
//
//  Created by Blaine Rothrock on 1/4/23.
//

import SwiftUI

struct SimpleBindingTextField: View {
    @State var text: String = ""
    
    var title: String
    var keyboardType: UIKeyboardType = .default
    var autoCompletion: Bool = true
    var capitaliation: TextInputAutocapitalization? = nil
    var onChange: ((String)->())?
    
    init(title: String, text: String, keyboardType: UIKeyboardType, autoCompletion: Bool, capitaliation: TextInputAutocapitalization?, onChange: ((String)->())?) {
        self._text = .init(initialValue: text)
        self.title = title
        self.keyboardType = keyboardType
        self.autoCompletion = autoCompletion
        self.capitaliation = capitaliation
        self.onChange = onChange
    }
    
    var body: some View {
        Text(title)
            .font(.callout)
            .bold()
        TextField(
            title,
            text: Binding<String>(
                get: { self.text },
                set: {
                    self.text = $0
                    onChange?(self.text)
                }
            )
        )
            .textFieldStyle(.roundedBorder)
            .textInputAutocapitalization(capitaliation)
            .keyboardType(keyboardType)
            .disableAutocorrection(autoCompletion)
    }
}
