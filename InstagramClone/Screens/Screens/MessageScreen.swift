//
//  MessageScreen.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 12/09/23.
//

import SwiftUI

struct MessageScreen: View {
    @Environment(\.dismiss) var dismiss ;
    @EnvironmentObject var messageStore : MessageStore ;
    @EnvironmentObject var authStore : AuthStore ; 
    var body: some View {
        VStack(alignment: .leading){
            HStack {
             
                    Image(systemName: "chevron.backward")
                    .onTapGesture {
                        dismiss()
                    }
                Text("A@a.com")
                    .tint(.black)
                    .foregroundColor(.black)
                    .font(.system(size: 26))
                Image(systemName: "chevron.down")
                Spacer()
                Image(systemName: "square.and.pencil")
            }
            Text("Messages")
                .bold()
                .padding(.top , 20)
            ScrollView {
                VStack{
                    if messageStore.state.messageListStatus == .success {
                        ForEach(messageStore.state.messageList, id: \.content) { message in
                            NavigationLink(destination: MessageDetailScreen(email: message.ownerEmail, username: message.ownerName)) {
                                UserTab(title: message.ownerName, caption: message.content)
                            }
                        }
                    } else {
                        Text(messageStore.state.messageListStatus.rawValue)
                        ProgressView()
                    }
                    
                }.frame(maxWidth: .infinity)
                
            }
            .padding(.top , 20)
        }
        .navigationBarBackButtonHidden(true)
        .padding()
        .onAppear{
            messageStore.dispatch(.recieveAll(authStore.state.email))
        }
      
    }
}

#Preview {
    MessageScreen()
        .environmentObject(MessageStore())
}
