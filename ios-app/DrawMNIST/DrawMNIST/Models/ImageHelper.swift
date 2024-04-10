//
//  ImageHelper.swift
//  DrawMNIST
//
//  Created by Dhruv Weaver on 4/10/24.
//

import UIKit

func resize(image: UIImage, to newSize: CGSize) -> UIImage? {
    guard image.size != newSize else {
        return image
    }

    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
    image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))

    defer { UIGraphicsEndImageContext() }
    return UIGraphicsGetImageFromCurrentImageContext()
}

func toPixelBuffer(image: UIImage) -> CVPixelBuffer? {
    var pixelBuffer: CVPixelBuffer? = nil

    let width = Int(image.size.width)
    let height = Int(image.size.height)

    CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_OneComponent8, nil, &pixelBuffer)
    CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue:0))

    let colorspace = CGColorSpaceCreateDeviceGray()
    let bitmapContext = CGContext(data: CVPixelBufferGetBaseAddress(pixelBuffer!), width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: colorspace, bitmapInfo: 0)!

    guard let cg = image.cgImage else {
        return nil
    }

    bitmapContext.draw(cg, in: CGRect(x: 0, y: 0, width: width, height: height))

    return pixelBuffer
}
