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

    func header() -> some View {
        HStack {
            Image(systemName: "chevron.backward")
                .onTapGesture {
                    dismiss()
                }
            Text(globalProfileStore.username)
                .tint(.black)
                .foregroundColor(.black)
                .font(.system(size: 26))
                .lineLimit(1)
            Spacer()
            Image(systemName: "square.and.pencil")
        }
    }
    
    var body: some View {
        VStack(alignment: .leading){
            header()
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
        .padding()
    }
}

#Preview {
    MessageScreen()
}
