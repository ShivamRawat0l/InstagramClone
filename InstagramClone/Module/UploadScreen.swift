//
//  Uploadscreen.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 10/09/23.
//

import SwiftUI
import PhotosUI
import AVKit
import CoreTransferable

struct UploadScreen: View {
    @EnvironmentObject var globalStore: GlobalStore
    @ObservedObject var uploadStore = UploadStore()

    @State var isImagePickerOpened = false
    @State var UIImageHolder: UIImage?;
    @State var UIVideoHolder: URL?

    var navigateToHome: () -> Void
    var imagePicked: PhotosPickerItem? {
        uploadStore.state.imagePicked
    }

    func toolbar() -> some ToolbarContent {
        Group {
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
    }

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                if uploadStore.state.imageUploadStatus == .pending {
                    ProgressView()
                }
                else if let UIImageHolder {
                    Image(uiImage: UIImageHolder)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                }
                else if let UIVideoHolder {
                   CustomVideoPlayer(url: UIVideoHolder)
                        .frame(width: 100)
                }
                TextField("Enter the title", text: $uploadStore.state.title)
                    .padding(.top, 10)
            }
            .padding(.vertical, 30)
            HStack {
                Text("Advanced Settings")
                Spacer()
                Image(systemName: Icons.chevronRight)
            }
            Spacer()
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
                        let videoURL = try await imagePicked.loadTransferable(type: Movie.self);
                        if let videoURL {
                            UIVideoHolder = videoURL.url
                        } else {
                            let image = try await imagePicked.loadTransferable(type: Data.self);
                            UIImageHolder = UIImage(data: image!)
                        }
                    }
                } catch {
                    print("UploadScreen.swift", error.localizedDescription)
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
            toolbar()
        }
        .photosPicker(isPresented: $isImagePickerOpened,
                      selection: $uploadStore.state.imagePicked,
                      matching: PHPickerFilter.any(of: [.images, .videos]))
    }
}

#Preview {
    NavigationView {
        UploadScreen(UIImageHolder: UIImage(systemName: Icons.cameraFill), navigateToHome: {})
    }
}
