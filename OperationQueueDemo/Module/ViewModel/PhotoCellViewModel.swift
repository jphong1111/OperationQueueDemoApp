//
//  OperationQueueCellViewModel.swift
//  OperationQueueDemo
//
//  Created by JungpyoHong on 5/4/21.
//

import UIKit

protocol PhotoProtocol {
    var title: String { get }
    var raw: String { get }
    var state: Photo.State { get set }
    var image: UIImage? { get set }
}

class PhotoCellViewModel: PhotoProtocol {
    let photo: Photo
    init(photo: Photo) {
        self.photo = photo
    }
    
    var title: String {
        photo.tags[0].source?.title ?? "No title"
    }
    
    var raw: String {
        photo.tags[0].source?.coverPhoto?.urls?.raw ?? "https://media.istockphoto.com/vectors/no-image-available-sign-vector-id922962354?k=6&m=922962354&s=612x612&w=0&h=_KKNzEwxMkutv-DtQ4f54yA5nc39Ojb_KPvoV__aHyU="
    }
    
    var state: Photo.State {
        get {
            photo.state
        }
        set {
            photo.state = newValue
        }
    }
    
    var image: UIImage? {
        get {
            guard let imageData = photo.image else { return nil }
            return UIImage(data: imageData)
        }
        set {
            photo.image = newValue?.pngData()
        }
    }
}

//protocol PhotoCellViewModelProtocol {
//    var photoImage: String { get }
//    var title: String { get }
//    var description: String { get }
//    var state: PhotoRecordState { get set }
//}
//
//class PhotoCellViewModel: PhotoCellViewModelProtocol {
//    var state: PhotoRecordState {
//        get {
//            state
//        }
//        set {
//            state =
//        }
//    }
//
//
//    private var photo: Photo
//
//    init(photo: Photo) {
//        self.photo = photo
//    }
//
//    var photoImage: String {
//        get {
//            photo.tags[0].source?.coverPhoto?.urls?.raw ?? "https://media.istockphoto.com/vectors/no-image-available-sign-vector-id922962354?k=6&m=922962354&s=612x612&w=0&h=_KKNzEwxMkutv-DtQ4f54yA5nc39Ojb_KPvoV__aHyU="
//
//        }
//    }
//
//    var title: String {
//        photo.tags[0].source?.title ?? "NO TITLE"
//    }
//
//    var description: String {
//        photo.tags[0].source?.description ?? "NO DESCRIPTION"
//    }
//}
