//
//  CustomShimmer.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 20/10/23.
//

import SwiftUI

struct CustomShimmer: View {
    @State var opacity = 1;

    var body: some View {
        Rectangle()
            .frame(alignment: .center)
            .opacity(1)
            .onAppear {

            }
    }
}

#Preview {
    CustomShimmer()
}
