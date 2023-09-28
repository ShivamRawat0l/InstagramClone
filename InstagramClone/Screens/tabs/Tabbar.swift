//
//  Tabbar.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 08/09/23.
//

import SwiftUI

struct Tabbar: View {
    @State var selectedIndex = 0
    
    func renderTab(_ unselectedName: String ,  
                   _ selectedName : String ,
                   isSelected : Bool , onSelectTab : @escaping () -> Void) -> some View {
        Group{
            if isSelected {
                return Image(systemName: selectedName)
                    .font(.system(size: 30))
            } else {
                return Image(systemName: unselectedName)
                    .font(.system(size: 30))
            }
        }
        .onTapGesture {
            onSelectTab()
        }
    }
    
    var icons = [
        ("house", "house.fill", 0 ),
        ("magnifyingglass.circle", "magnifyingglass.circle.fill", 1 ),
        ("plus.circle", "plus.circle.fill", 2 ),
        ("person.crop.circle", "person.crop.circle.fill", 3 )
    ]
    
    var body: some View {
        VStack {
            if selectedIndex == 0 {
                HomeScreen()
            } else if selectedIndex == 1 {
                SearchScreen()
            } else if selectedIndex == 2 {
                UploadScreen()
            } else if selectedIndex == 3 {
                ProfileScreen()
            }
            Spacer()
            HStack{
                Spacer()
                ForEach(icons, id: \.self.2) { icons  in
                    renderTab(icons.0, icons.1, isSelected: selectedIndex == icons.2) {
                        selectedIndex = icons.2
                    }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    Tabbar()
        .environmentObject(AuthStore(state: AuthState(username: "",
                                                      email: "temp@temp.com", 
                                                      password: "temp",
                                                      loginAuthStatus: .success("A@a.com"),
                                                      signupAuthStatus: .success("B@b.com"))))
}
