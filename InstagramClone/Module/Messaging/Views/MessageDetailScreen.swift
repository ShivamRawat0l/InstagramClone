//
//  MessageScreen.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 08/09/23.
//

import SwiftUI

struct MessageDetailScreen: View {
    var email: String
    var username: String
    
    @State var sendText = ""
    
    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var globalStore: GlobalStore

    @ObservedObject var messageStore = MessageStore()

    var globalProfileStore: GlobalProfileState {
        globalStore.state.profileState
    }

    var globalMessageStore: GlobalMessageState {
        globalStore.state.messageState
    }

    func header() -> some View {
        HStack {
            Rectangle()
                .fill(.white)
                .frame(width: 40, height: 40)
                .zIndex(1)
                .overlay {
                    Image(systemName: "chevron.backward")
                }
                .onTapGesture {
                    dismiss()
                }
            
            AsyncImage(url: URL(string: Constant.getImageUrl(title: email)))
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(email)
                Text(username)
                    .lineLimit(1)
            }
            Spacer()
            Image(systemName: "phone")
            Image(systemName: "video")
        }
        .padding()
    }
    
    var body: some View {
        VStack {
            header()
            
            ScrollView{
                VStack {
                    ForEach(globalMessageStore.selectedMessage.enumerated().reversed(),
                            id : \.offset) { index, message in
                        Text(message.content)
                            .foregroundStyle(.white)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(message.isOwner ? .blue : .gray)
                            }
                            .rotationEffect(.degrees(180))
                            .scaleEffect(x: -1, y: 1, anchor: .center)
                            .frame(maxWidth: .infinity,alignment: message.isOwner ? .trailing : .leading)
                    }
                }
                .padding()
            }
            .rotationEffect(.degrees(180))
            .scaleEffect(x: -1, y: 1, anchor: .center)
            HStack {
                Image(systemName: "camera.fill")
                TextField("Hello",text:  $sendText)
                Spacer()
                if sendText == "" {
                    Image(systemName: "mic")
                    Image(systemName: "photo")
                } else {
                    Button {
                        let sendAction = MessageAction.send((email,username),
                                                            (globalProfileStore.email,globalProfileStore.username),
                                                            sendText)
                        messageStore.dispatch(sendAction)
                        sendText = ""
                    } label : {
                        Image(systemName: "paperplane.fill")
                    }
                    
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: {
            globalStore.dispatch(.messageAction(.selectUserMessage((email,username),
                                                        (globalProfileStore.email,globalProfileStore.username))))
        })
    }
}

#Preview {
    MessageDetailScreen(email:"A@a.com", username: "A_a")
}
