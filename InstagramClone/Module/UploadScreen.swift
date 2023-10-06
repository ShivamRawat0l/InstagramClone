//
//  Uploadscreen.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 10/09/23.
//

import SwiftUI
import PhotosUI

struct UploadScreen: View {
    @State var imagePicked: PhotosPickerItem?
    @State var UIImageHolder: UIImage?;

    @State var title = ""

    var body: some View {
        Button {
            print("wok")
        } label : {
            Text("Hi ")
        }
        Text("Upload Screen")
        if let UIImageHolder {
            Image(uiImage: UIImageHolder)
        }
        PhotosPicker(selection: $imagePicked) {
            Text("Upload Photo")
        }
        .onChange(of: imagePicked) {
            Task {
                do {
                    let image = try await imagePicked?.loadTransferable(type: Data.self);
                    UIImageHolder = UIImage(data: image!)
                } catch {

                }
            }
        }
        TextField("Enter the title", text: $title)
    }
}

#Preview {
    UploadScreen()
}
