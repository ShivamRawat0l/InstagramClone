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
    @EnvironmentObject var profileStore : ProfileStore;
    
    func header() -> some View {
        HStack {
                Image(systemName: "chevron.backward")
                .onTapGesture {
                    dismiss()
                }
            Text(profileStore.state.username)
                .tint(.black)
                .foregroundColor(.black)
                .font(.system(size: 26))
                .lineLimit(1)
            Image(systemName: "chevron.down")
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
                    let _ = print("message ",messageStore.state.messageList)
                    if messageStore.state.messageListStatus == .success {
                        ForEach(messageStore.state.messageList, id: \.ownerName) { message in
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
    }
}

#Preview {
    MessageScreen()
        .environmentObject(MessageStore())
        .environmentObject(ProfileStore())
}
