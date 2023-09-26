//
//  MessageScreen.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 08/09/23.
//

import SwiftUI

struct MessageDetailScreen: View {
    var email : String;
    var username : String;
    @State var sendText = "";
    
    @Environment(\.dismiss) var dismiss;
    @EnvironmentObject var authStore : AuthStore ;
    @EnvironmentObject var messageStore : MessageStore ;
    @EnvironmentObject var profileStore : ProfileStore;
    
    func header() -> some View {
        HStack {
            Rectangle()
                .fill(.white)
                .frame(width: 40, height: 40)
                .overlay {
                    Image(systemName: "chevron.backward")
                    
                }
                .onTapGesture {
                    dismiss()
                }
            AsyncImage(url: URL(string: Constant.getImageUrl(title: email)))
                .frame(width: 40,height: 40)
                .clipShape(Circle())
            VStack(alignment: .leading) {
                Text(email)
                Text(username)
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
            
            Button {
                messageStore.dispatch(.resetMessages)
                dismiss()
            } label : {
                Text("Dismiss")
            }
            
            ScrollView{
                VStack {
                    ForEach(messageStore.state.selectedMessage.enumerated().reversed(), id : \.offset) { index, message in
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
                if sendText != nil ,sendText == "" {
                    Image(systemName: "mic")
                    Image(systemName: "photo")
                } else {
                    Button {
                        messageStore.dispatch(.send((email,username),(profileStore.state.email,profileStore.state.username), sendText))
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
            messageStore.dispatch(.select((email,username),(profileStore.state.email,profileStore.state.username)))
        })
    }
}

#Preview {
    MessageDetailScreen(email :"A@a.com", username: "A_a")
        .environmentObject(AuthStore(state: AuthState(username: "",email: "temp@temp.com", password: "temp", loginAuthStatus: .success, signupAuthStatus: .success)))
        .environmentObject(MessageStore())
}
