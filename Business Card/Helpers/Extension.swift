//
//  Extension.swift
//  Bolts
//
//  Created by Arsalan Iravani on 1/9/19.
//

import UIKit
import Foundation

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> UIImage? {
        return UIImage(data: jpegData(compressionQuality: jpegQuality.rawValue)!)
    }
}
