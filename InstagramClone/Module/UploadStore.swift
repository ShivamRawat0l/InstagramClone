//
//  UploadStore.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 12/10/23.
//

import Foundation

@MainActor
class UploadStore: ObservableObject {
    @Published var state: UploadState
    var uploadService: UploadService

    init(state: UploadState = UploadState(), uploadService: UploadService = UploadService()) {
        self.state = state
        self.uploadService = uploadService
    }

    func dispatch(_ action: UploadAction) async {
        self.state = await self.reducer(state, action)
    }

    func reducer(_ state: UploadState, _ action: UploadAction) async -> UploadState {
        var mutableState = state
        
        switch(action){ 
        case .unselectImage:
            mutableState.imagePicked = nil
        case .upload(let image, let owner):
            await uploadService.postImageToInstagramClone(title: state.title, image: image, owner: owner)
        }
        
        return mutableState
    }

}
