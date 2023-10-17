//
//  Uploadscreen.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 10/09/23.
//

import SwiftUI
import PhotosUI

struct UploadScreen: View {
    @ObservedObject var uploadStore = UploadStore()
    @EnvironmentObject var globalStore: GlobalStore

    @State var isImagePickerOpened = false
    var imagePicked: PhotosPickerItem? {
        uploadStore.state.imagePicked
    }

    @State var UIImageHolder: UIImage?;

    var body: some View {
        VStack {
            if let UIImageHolder {

                TextField("Enter the title", text: $uploadStore.state.title)
                    .textFieldStyle(DefaultInputStyle())
                Image(uiImage: UIImageHolder)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 400)
                Button {
                    Task {
                        do {
                            let imageData = try await uploadStore.state.imagePicked?.loadTransferable(type: Data.self)
                            let uiImage = UIImage(data: imageData!)
                            let compressedImage = uiImage?.jpegData(compressionQuality: 0.5)
                            await uploadStore.dispatch(.upload(compressedImage!, globalStore.state.profileState.username))
                        }
                        catch {
                            print("errror occured")
                        }
                    }
                } label: {
                    Text("Send to the storage.")
                }
            }

            if imagePicked != nil {
                Button {
                    Task {
                        await uploadStore.dispatch(.unselectImage)
                    }
                } label: {
                    Text("Discard Image")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Upload Post")
        .onAppear {
            isImagePickerOpened = true

        }
        .onChange(of: imagePicked) {
            Task {
                do {
                    if let imagePicked {
                        let image = try await imagePicked.loadTransferable(type: Data.self);
                        UIImageHolder = UIImage(data: image!)
                    }
                } catch {

                }
            }
        }
        .photosPicker(isPresented: $isImagePickerOpened, selection: $uploadStore.state.imagePicked)
    }
}

#Preview {
    UploadScreen()
}
