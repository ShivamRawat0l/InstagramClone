//
//  Inputmodifer.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 10/09/23.
//

import SwiftUI

struct DefaultInputStyle: TextFieldStyle {

    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.gray, lineWidth: 2)
            )
    }
}


#Preview {
    TextField("Hello", text: .constant("hi"))
        .textFieldStyle(DefaultInputStyle())
}
