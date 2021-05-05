//
//  PhotoAPI.swift
//  OperationQueueDemo
//
//  Created by JungpyoHong on 5/4/21.
//

import Foundation

enum PhotoAPI: EndPoint {
    case list
    
    var path: String {
        switch self {
        case .list:
            return ""
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: "https://api.unsplash.com/collections/?client_id=2TZgdxa0VJ5bOq4Kbdd0ITUxRUgNN7Fk5kVm87EsloU") else {
            fatalError("Bad Base Url")
        }
        return url
    }
    
    var task: HTTPTask {
        .request
    }
}
