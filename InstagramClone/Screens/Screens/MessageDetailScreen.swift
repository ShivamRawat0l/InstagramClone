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
                Button {
                    print("HERE")
                    dismiss()
                } label : {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 20))
                        .padding(.leading, 10)
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
            ScrollView{
                VStack {
                    ForEach(messageStore.state.selectedMessage, id : \.self.content) { message in
                        Text(message.content)
                            .foregroundStyle(.white)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.blue)
                            }
                            .rotationEffect(.degrees(180))
                            .scaleEffect(x: -1, y: 1, anchor: .center)
                            .frame(maxWidth: .infinity,alignment:.trailing)
                        
                    }
                }
                
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
                        print(email , authStore.state.email)
                        messageStore.dispatch(.send(email, authStore.state.email, sendText))
                        messageStore.dispatch(.select(email,authStore.state.email))
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
            messageStore.dispatch(.select(email,authStore.state.email))
        })
    }
}

#Preview {
    MessageDetailScreen(email :"A@a.com", username: "A_a")
}
