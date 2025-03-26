//
//  APITask.swift
//  PeepIt
//
//  Created by 김민 on 3/11/25.
//

import Foundation
import Alamofire

enum APITask {
    /// 추가 데이터가 없는 request
    case requestPlain
    /// Encodable을 채택하는 body를 포함하는 request
    case requestJSONEncodable(body: Encodable)
    /// Parameter을 포함하는 request
    case requestParameters(parameters: Parameters)
    /// Interceptor를 포함하지 않는 request
    case requestWithoutInterceptor(parameters: Parameters)
}
