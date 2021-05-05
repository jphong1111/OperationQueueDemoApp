//
//  Photo.swift
//  OperationQueueDemo
//
//  Created by JungpyoHong on 5/4/21.
//

import Foundation


class Photo: Decodable {
    
    enum State: Int, Decodable {
        case new, downloaded, failed, filtered
    }
    
    var tags: [Tags]
    var state = State.new
    var image: Data?

    init(tag: [Tags]) {
        self.tags = tag
    }
}

class Tags: Decodable {
    var source: Source?
    
    init(source: Source) {
        self.source = source
    }
}

class Source: Decodable {
    var title: String
    var coverPhoto: CoverPhoto?
    
    enum CodingKeys: String, CodingKey {
        case title
        case coverPhoto = "cover_photo"
    }
    
    init(title: String, coverPhoto: CoverPhoto) {
        self.title = title
        self.coverPhoto = coverPhoto
    }
}

class CoverPhoto: Decodable {
    var urls: ImageURL?
    
    init(urls: ImageURL) {
        self.urls = urls
    }
}

class ImageURL: Decodable {
    var raw: String?
    
    init(raw: String) {
        self.raw = raw
    }
}
