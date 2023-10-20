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
                    let imageData = try await self.state.imagePicked?.loadTransferable(type: Data.self)
                    let uiImage = UIImage(data: imageData!)
                    let compressedImage = uiImage?.jpegData(compressionQuality: 0.5)
                    try await uploadService.postImageToInstagramClone(title: state.title, image: compressedImage!, owner: owner)
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
