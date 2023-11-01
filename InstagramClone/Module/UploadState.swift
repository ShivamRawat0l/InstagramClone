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
    var imagePicked: PhotosPickerItem?
    var UIImageHolder: UIImage?
    var imageUploadStatus: AsyncStatus = .inital
    var title: String = .empty
}

struct Movie: Transferable {
  let url: URL
  // TASK: Read This Code
  static var transferRepresentation: some TransferRepresentation {
    FileRepresentation(contentType: .movie) { movie in
      SentTransferredFile(movie.url)
    } importing: { receivedData in
      let fileName = receivedData.file.lastPathComponent
      let copy: URL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

      if FileManager.default.fileExists(atPath: copy.path) {
        try FileManager.default.removeItem(at: copy)
      }

      try FileManager.default.copyItem(at: receivedData.file, to: copy)
      return .init(url: copy)
    }
  }
}
