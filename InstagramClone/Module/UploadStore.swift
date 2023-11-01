//
//  UploadStore.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 12/10/23.
//

import Foundation
import SwiftUI

@MainActor
class UploadStore: ObservableObject {

    @MainActor @Published var state: UploadState

    var uploadService: UploadService

    init(state: UploadState = UploadState(), uploadService: UploadService = UploadService()) {
        self.state = state
        self.uploadService = uploadService
    }

    func dispatch(_ action: UploadAction) {
        self.state = self.reducer(state, action)
    }

    func reducer(_ state: UploadState, _ action: UploadAction) -> UploadState {
        var mutableState = state

        switch(action){
        case .unselectImage:
            mutableState.imagePicked = nil
        case .upload(let owner):
            Task {
                do {
                    self.dispatch(.setUploadStatus(.pending))
                    var mediaData: Data?
                    var fileExtension: String = ""
                    let videoURL = try await self.state.imagePicked?.loadTransferable(type: Movie.self);
                    mediaData = try await self.state.imagePicked?.loadTransferable(type: Data.self)
                    if let videoURL {
                        fileExtension = "." + videoURL.url.absoluteString.components(separatedBy: ".").last!
                    } else {
                        // Note: It means that it is a image so we are applying some compression
                        mediaData = UIImage(data: mediaData!)?.jpegData(compressionQuality: 0.5)
                    }
                    try await uploadService.postImageToInstagramClone(title: state.title,
                                                                      media: mediaData!,
                                                                      owner: owner,
                                                                      isMediaVideo: videoURL != nil,
                                                                      fileExtension: fileExtension)
                    self.dispatch(.setUploadStatus(.success))
                } catch {
                    self.dispatch(.setUploadStatus(.failure))
                    print("Error occurred @UploadStore.upload", error.localizedDescription)
                }
            }

        case .setUploadStatus(let status):
            mutableState.imageUploadStatus = status
        }

        return mutableState
    }

}
