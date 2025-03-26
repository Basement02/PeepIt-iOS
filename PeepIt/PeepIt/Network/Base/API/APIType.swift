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
        return ["Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiJzYW1wbGVfdXNlcnVzZXJ1c2VyIiwicm9sZSI6IlVOQ0VSVCIsImlzcyI6Imh0dHBzOi8vYXV0aC5wZWVwaXQuY29tIiwiaWF0IjoxNzQyODg5OTM1LCJleHAiOjE3NDU0ODE5MzV9.gPrFBI3EfnaPED6rsZHNM2vCQSD8dDg9pQ5tjJZAXuc"] // TODO: JWT 토큰 수정
    }
}
