//
//  UploadState.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 12/10/23.
//

import Foundation
import PhotosUI
import SwiftUI

struct UploadState {
     var isImagePickerOpened = false // TODO: Handle this
     var imagePicked: PhotosPickerItem?
     var UIImageHolder: UIImage?

     var title: String = .empty
}
