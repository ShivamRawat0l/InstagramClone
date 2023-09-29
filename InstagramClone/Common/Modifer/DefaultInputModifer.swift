//
//  Inputmodifer.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 10/09/23.
//

import SwiftUI

struct DefaultInputModifer : ViewModifier {
    
    func body (content: Content) -> some View {
        content
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.gray, lineWidth: 2)
            )
    }
}

extension View {
    func defaultInput() -> some View {
        return ModifiedContent(
            content: self,
            modifier: DefaultInputModifer()
        )
    }
}

#Preview {
    TextField("Hello", text: .constant("hi")).defaultInput()
}
