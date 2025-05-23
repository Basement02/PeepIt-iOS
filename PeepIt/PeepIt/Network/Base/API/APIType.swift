//
//  APIType.swift
//  PeepIt
//
//  Created by 김민 on 3/11/25.
//

import Foundation
import Alamofire

protocol APIType {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var task: APITask { get }
    var header: HeaderType { get }
}

extension APIType {

    var baseURL: URL {
        return URL(string: Environment.baseURL)!
    }

    var header: HeaderType {
        return .none
    }
}
