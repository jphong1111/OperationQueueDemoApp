//
//  HTTPTask.swift
//  OperationQueueDemo
//
//  Created by JungpyoHong on 5/4/21.
//

import Foundation

typealias HTTPHeaders = [String: String]

enum HTTPTask {
    case request
    
    case requestParameters(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?)
    
    case requestParametersAndHeaders(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?)
}
