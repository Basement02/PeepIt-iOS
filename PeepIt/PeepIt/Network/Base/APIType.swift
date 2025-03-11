//
//  APIType.swift
//  PeepIt
//
//  Created by 김민 on 3/11/25.
//

import Foundation
import Alamofire

protocol TargetType {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var task: APITask { get }
    var header: HTTPHeaders? { get }
}

extension TargetType {

    var baseURL: URL {
        return URL(string: NetworkEnvironment.baseURL)!
    }

    var header: HTTPHeaders? {
        return nil
    }
}
