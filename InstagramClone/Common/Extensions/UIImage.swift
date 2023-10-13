//
//  View.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 13/10/23.
//

import Foundation
import SwiftUI

extension UIImage {
  func resizeImage(with size: CGSize) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    draw(in: CGRect(origin: .zero, size: size))
    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return resizedImage
  }
}
