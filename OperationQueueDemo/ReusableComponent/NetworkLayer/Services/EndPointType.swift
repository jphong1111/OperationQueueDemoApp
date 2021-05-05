//
//  EndPointType.swift
//  OperationQueueDemo
//
//  Created by JungpyoHong on 5/4/21.
//

import Foundation

protocol EndPoint {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

extension EndPoint {
    var baseURL: URL {
        guard let url = URL(string: "https://api.unsplash.com/collections/?client_id=2TZgdxa0VJ5bOq4Kbdd0ITUxRUgNN7Fk5kVm87EsloU") else {
            fatalError("baseURL Error")
        }
        return url
    }
    
    var httpMethod: HTTPMethod {
        .get
    }
    
    var task: HTTPTask {
        .request
    }
    
    var headers: HTTPHeaders? {
        nil
    }
}
