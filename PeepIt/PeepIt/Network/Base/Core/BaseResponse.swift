//
//  BaseResponse.swift
//  PeepIt
//
//  Created by 김민 on 3/11/25.
//

import Foundation

struct ExceptionDTO: Decodable {
    var code: String
    var message: String
}

struct BaseResponse<T: Decodable>: Decodable {
    let success: Bool
    let data: T?
    let error: ExceptionDTO?

    enum CodingKeys: String, CodingKey {
        case success
        case data
        case error
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = (try? container.decode(Bool.self, forKey: .success)) ?? false
        data = (try? container.decode(T.self, forKey: .data)) ?? nil
        error = (try? container.decode(ExceptionDTO.self, forKey: .error)) ?? nil
    }
}

struct EmptyDecodable: Decodable {}
