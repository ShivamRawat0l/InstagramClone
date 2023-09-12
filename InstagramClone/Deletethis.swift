//
//  Deletethis.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 08/09/23.
//

import SwiftUI

struct Deletethis: View {
    @State private var state: Int = 0

    var isStateEqualToOne: Bool {
        return state == 1
    }

    var body: some View {
        VStack {
            Text("State: \(state)")
            Button {
                state += 1
            } label: {
                 Text("Increment")
            }
            AnotherComponent(condition: isStateEqualToOne)
        }
    }
}

struct AnotherComponent: View {
    var condition: Bool

    var body: some View {
        if condition {
            Text("Condition is true (State is equal to 1)")
        } else {
            Text("Condition is false (State is not equal to 1)")
        }
    }
}

struct Deletethis_Previews: PreviewProvider {
    static var previews: some View {
        Deletethis()
    }
}
