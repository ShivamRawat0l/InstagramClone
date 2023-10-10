//
//  MessageScreen.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 12/09/23.
//

import SwiftUI

struct MessageScreen: View {
    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var globalStore: GlobalStore

    var globalMessageStore: GlobalMessageState {
        globalStore.state.messageState
    }

    var globalProfileStore : GlobalProfileState {
        globalStore.state.profileState
    }

    var body: some View {
        VStack(alignment: .leading){
            Text("Messages")
                .bold()
                .padding(.top , 20)
            ScrollView {
                VStack{
                    if globalMessageStore.messageListStatus == .success {
                        ForEach(globalMessageStore.messageList, id: \.ownerName) { message in
                            let messageDetailsScreen = MessageDetailScreen(email: message.ownerEmail,
                                                                           username: message.ownerName)
                            NavigationLink(destination: messageDetailsScreen) {
                                UserTab(title: message.ownerName, caption: message.content)
                            }
                        }
                    } else {
                        Text(globalMessageStore.messageListStatus.rawValue)
                        ProgressView()
                    }
                }.frame(maxWidth: .infinity)

            }
            .padding(.top, 20)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundStyle(.black)
                }
            }
            ToolbarItem(placement: .principal) {
                Text(globalProfileStore.username)
                    .tint(.black)
                    .foregroundColor(.black)
                    .font(.regular26)
                    .lineLimit(1)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "square.and.pencil")
            }
        }
        .padding()
    }
}

#Preview {
    MessageScreen()
}
