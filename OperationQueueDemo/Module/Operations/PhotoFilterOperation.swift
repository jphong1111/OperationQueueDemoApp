//
//  PhotoFilterOperation.swift
//  OperationQueueDemo
//
//  Created by JungpyoHong on 5/4/21.
//

import UIKit

class PhotoFilterOperation: Operation {
    var photo: PhotoProtocol
    
    init(photo: PhotoProtocol) {
        self.photo = photo
    }
    override func main() {
        if isCancelled {
            return
        }
        guard photo.state == .downloaded else { return }
        guard let image = photo.image,
              let filterApplied = CIFilter(name: "CISepiaTone"),
               let filterImage = filter(image: image, option: filterApplied) else {
            return
        }
        photo.image = filterImage
        photo.state = .filtered
    }
    func filter(image: UIImage, option: CIFilter) -> UIImage? {
        guard let data = image.jpegData(compressionQuality: 0.5) else { return nil }
        let imageToFilter = CIImage(data: data)
        if isCancelled {
            return nil
        }
        option.setValue(imageToFilter, forKey: kCIInputImageKey)
        option.setValue(0.8, forKey: kCIInputIntensityKey)
        if isCancelled {
            return nil
        }
        let context = CIContext(options: nil)
        guard let outputImage = option.outputImage,
              let finalImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        return UIImage(cgImage: finalImage)
    }
}
