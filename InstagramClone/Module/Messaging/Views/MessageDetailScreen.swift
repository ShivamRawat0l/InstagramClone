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
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var globalStore: GlobalStore
    @ObservedObject var messageStore = MessageStore()
    @State var sendText = ""

    var globalProfileStore: GlobalProfileState {
        globalStore.state.profileState
    }

    var globalMessageStore: GlobalMessageState {
        globalStore.state.messageState
    }
    
    var body: some View {
        VStack {
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
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack{

                    Rectangle()
                        .fill(.clear)
                        .frame(width: 40, height: 40)
                        .zIndex(1)
                        .overlay {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "chevron.backward")
                            }
                        }
                    AsyncImage(url: URL(string: Constant.getImageUrl(title: email)))
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())


                }
            }
            ToolbarItem(placement: .principal) {
                HStack {
                    VStack {
                        Text(email)
                            .frame(alignment: .leading)

                        Text(username)
                            .lineLimit(1)
                    }
                    Spacer()

                }

            }
            ToolbarItem(placement: .topBarTrailing) {
                HStack{
                    Image(systemName: "phone")
                    Image(systemName: "video")
                }
            }

        }
        .onAppear(perform: {
            globalStore.dispatch(.messageAction(.selectUserMessage((email,username),
                                                        (globalProfileStore.email,globalProfileStore.username))))
        })
    }
}

#Preview {
    MessageDetailScreen(email:"A@a.com", username: "A_a")
}
