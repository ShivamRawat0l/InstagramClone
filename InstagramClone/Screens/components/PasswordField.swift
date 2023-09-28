//
//  InputField.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 07/09/23.
//

import SwiftUI

struct PasswordField: View {
    var title = ""
    
    @Binding var text: String
    
    @State var isSecured = true
    
    var body: some View {
        if isSecured {
            SecureField(title, text: $text)
                .frame(height: 22)
                .defaultInput()
                .showPasswordIcon {
                    isSecured = false;
                }
        } else {
            TextField(title, text: $text)
                .frame(height: 22)
                .defaultInput()
                .showPasswordIcon {
                    isSecured = true;
                }
        }
    }
}

#Preview {
    PasswordField(title: "" , text: .constant(""))
}
