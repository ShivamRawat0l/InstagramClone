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
    
    var body: some View {
        VStack {
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
            Button {
                messageStore.dispatch(.resetMessages)
           dismiss()
            } label : {
                Text("Dismiss")
            }
            ScrollView{
                VStack {
                    ForEach(messageStore.state.selectedMessage.reversed(), id : \.self.content) { message in
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
                        messageStore.dispatch(.send((email,username),(authStore.state.email,authStore.state.email == "A@a.com" ? "A_a": "B_b"), sendText))
                      //  messageStore.dispatch(.select((email,username),(authStore.state.email,authStore.state.email == "A@a.com" ? "A_a": "B_b")))
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
            messageStore.dispatch(.select((email,username),(authStore.state.email,authStore.state.email == "A@a.com" ? "A_a": "B_b")))
        })
    }
}

#Preview {
    MessageDetailScreen(email :"A@a.com", username: "A_a")
        .environmentObject(AuthStore(state: AuthState(username: "",email: "temp@temp.com", password: "temp", loginAuthStatus: .success, signupAuthStatus: .success)))
        .environmentObject(MessageStore())
}
