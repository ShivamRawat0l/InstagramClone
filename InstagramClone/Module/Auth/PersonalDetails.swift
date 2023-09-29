//
//  PersonalDetails.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 10/09/23.
//

import SwiftUI

struct PersonalDetails: View {
    @State var name;
    var body: some View {
        Text("Personal Details")
        TextField("Name", text:$name )
        TextField("Name", text:$name )
        TextField("Name", text:$name )
    }
}

#Preview {
    PersonalDetails()
}
