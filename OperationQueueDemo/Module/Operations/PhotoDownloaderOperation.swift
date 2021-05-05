//
//  PhotoDownloaderOperation.swift
//  OperationQueueDemo
//
//  Created by JungpyoHong on 5/4/21.
//

import UIKit

class PhotoDownloaderOperation: Operation {
    
    var photo: PhotoProtocol
    
    init(photo: PhotoProtocol) {
        self.photo = photo
    }
    
    override func main() {
        if isCancelled {
            return
        }
        guard let url = URL(string: photo.raw) else {
            fatalError("Url not valid")
        }
        
        do {
            let imageData = try Data(contentsOf: url)
            if isCancelled {
                return
            }
            guard !imageData.isEmpty else {
                // set placeholder for failed image
                photo.image = nil
                photo.state = .failed
                return
            }
            photo.image = UIImage(data: imageData)
            photo.state = .downloaded
        }
        catch {
            // handle error here
            photo.image = nil
            photo.state = .failed
        }
    }
}
