//
//  InputField.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 07/09/23.
//

import SwiftUI

struct InputField: View {
    @State var a : String = "";
    var body: some View {
        SecureField("Hello",text: $a)
            .padding()
            .font(.system(size: 30))
            .textFieldStyle(RoundedBorderTextFieldStyle())
          
    }
}

#Preview {
    InputField()
}
