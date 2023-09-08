//
//  PrimaryButton.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 07/09/23.
//

import SwiftUI

struct PrimaryButton: View {
    var text : String = "Placeholder"
    @State var loading : Bool = false;
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.blue)
            .frame(height: 50)
            .padding()
            .overlay {
                if !loading {
                    Text(text)
                        .foregroundColor(.white)
                } else {
                    ProgressView()
                        .tint(.white)
                }
                
            }
    }
}

#Preview {
    PrimaryButton()
}
