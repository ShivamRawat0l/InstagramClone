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

    var navigateToHome: () -> Void

    @State var isImagePickerOpened = false

    var imagePicked: PhotosPickerItem? {
        uploadStore.state.imagePicked
    }

    @State var UIImageHolder: UIImage?;

    var body: some View {
        VStack {
            if uploadStore.state.imageUploadStatus == .pending {
                ProgressView()
            }
            else if let UIImageHolder {
                Image(uiImage: UIImageHolder)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 300)
                    .padding(.vertical, 30)
                TextField("Enter the title", text: $uploadStore.state.title)
                    .textFieldStyle(.roundedBorder)
                Spacer()
            }
        }
        .padding()
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
        .onChange(of: uploadStore.state.imageUploadStatus) {
            if uploadStore.state.imageUploadStatus == .success {
                navigateToHome()
            }
        }
        .onChange(of: isImagePickerOpened) {
            if isImagePickerOpened == false && imagePicked == nil {
                navigateToHome()
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    uploadStore.dispatch(.unselectImage)
                    navigateToHome()
                } label: {
                    Image(systemName: Icons.cancel)
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    uploadStore.dispatch(.upload(globalStore.state.profileState.email))
                } label: {
                    Text("Post")
                }
                .disabled(uploadStore.state.title.count == 0)
            }
        }
        .photosPicker(isPresented: $isImagePickerOpened,
                      selection: $uploadStore.state.imagePicked,
                      matching: .images)
    }
}

#Preview {
    NavigationView {
        UploadScreen(navigateToHome: {}, UIImageHolder: UIImage(systemName: Icons.cameraFill))
    }
}
