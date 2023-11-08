//
//  CustomShimmer.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 20/10/23.
//

import SwiftUI

struct CustomShimmer: View {
    @State var opacity = 1;
    @State var moveTo = -1.3
    var shimmerHeight: Double
    var height: Double

    init(height: Double) {
        self.height = height
        self.shimmerHeight = height > 300 ? height : 300
    }

    var body: some View {
        Rectangle()
            .fill(.gray)
            .frame(height: height, alignment: .center)
            .overlay {
                Rectangle()
                    .fill(.white)
                    .frame(width: shimmerHeight * 2.25)
                    .mask {
                        Rectangle()
                            .fill(
                                .linearGradient(colors: [
                                    .white.opacity(0),
                                    .gray.opacity(0.8),
                                    .white.opacity(0)
                                ], startPoint: .top, endPoint: .bottom)
                            )
                            .frame(height: 1600)
                            .blur(radius: 2)
                            .rotationEffect(.init(degrees: -70))
                            .offset(x: height * moveTo, y: 0)
                    }
            }
            .onAppear {
                moveTo = 0.8
            }
            .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: moveTo)
    }
}

#Preview {
    CustomShimmer(height: 100)
}
