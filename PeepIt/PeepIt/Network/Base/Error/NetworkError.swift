//
//  NetworkError.swift
//  PeepIt
//
//  Created by 김민 on 3/11/25.
//

import Foundation

enum NetworkError: Error {
    case noResponse
    case emptyData
    case invalidResponse
    case decodingFailed
    case unknown
    case serverError(ExceptionDTO)
}
