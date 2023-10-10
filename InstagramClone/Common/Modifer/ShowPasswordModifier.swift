//
//  Inputmodifer.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 10/09/23.
//

import SwiftUI

struct ShowPasswordModifier: ViewModifier {
    var onPressBtn: () -> Void;

    func body (content: Content) -> some View {
        content
            .overlay {
                Button {
                    onPressBtn()
                } label: {
                    HStack{
                        Spacer()
                        Image(systemName: Icons.eyeFill)
                            .padding()
                    }
                }
            }
    }
}

extension View {
    func showPasswordIcon(onPressBtn: @escaping () -> Void) -> some View {
        return ModifiedContent(
            content : self,
            modifier : ShowPasswordModifier(onPressBtn: onPressBtn)
        )
    }
}

#Preview {
    TextField("Hello", text: .constant("hi"))
        .textFieldStyle(DefaultInputStyle())
        .showPasswordIcon {
            //
        }
}
