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
    var header: HTTPHeaders? { get }
}

extension APIType {

    var baseURL: URL {
        return URL(string: Environment.baseURL)!
    }

    var header: HTTPHeaders? {
        return ["Authorization": "Bearer JWT_TOKEN"] // TODO: JWT 토큰 수정
    }
}
