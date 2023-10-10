//
//  PrimaryButton.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 07/09/23.
//

import SwiftUI

struct PrimaryButton: View {
    var text = T.General.Placeholder
    var loading = false
    var onPress: () -> Void

    var body: some View {
        Button {
            onPress()
        } label: {
            RoundedRectangle(cornerRadius: 10)
                .fill(.blue)
                .frame(height: 50)
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
}

#Preview {
    PrimaryButton() {
        print("Button Pressed")
    }
}
