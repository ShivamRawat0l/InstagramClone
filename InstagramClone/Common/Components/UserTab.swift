//
//  UserTab.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 12/09/23.
//

import SwiftUI

struct UserTab: View {
    var title: String
    var caption: String
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: Constant.getImageUrl(title: title)))
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            VStack(alignment: .leading) {
                Text(title)
                    .bold()
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                Text(caption)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
            }
            .padding(.leading, 20)
            Spacer()
        }
    }
}

#Preview {
    UserTab(title: "A@a.com", caption: "Seen Just Now")
}
