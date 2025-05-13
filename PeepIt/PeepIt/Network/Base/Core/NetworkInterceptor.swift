//
//  NetworkInterceptor.swift
//  PeepIt
//
//  Created by 김민 on 5/13/25.
//

import Foundation
import Alamofire

final class NetworkInterceptor: RequestInterceptor {

    private let keychain: KeychainClient
    private let requestHeader: HeaderType

    init(keychain: KeychainClient, requestHeader: HeaderType) {
        self.keychain = keychain
        self.requestHeader = requestHeader
    }

    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, any Error>) -> Void
    ) {
        var adaptedRequest = urlRequest

        // (1) 고정 헤더일 때 - 카카오
        if let staticHeader = requestHeader.staticHeader {
            adaptedRequest.headers.add(staticHeader)
            completion(.success(adaptedRequest))
            return
        }

        // (2) 토큰 필요 없을 때
        guard let tokenKey = requestHeader.tokenKey else {
            completion(.success(urlRequest))
            return
        }

        // (3) 토큰이 필요한 경우
        guard let token = keychain.load(tokenKey) else {
            debugPrint("토큰 없음: \(tokenKey)")
            completion(.success(urlRequest))
            return
        }

        let header = HTTPHeader(name: "Authorization", value: "\(requestHeader.prefix) \(token)")
        adaptedRequest.headers.add(header)
        completion(.success(adaptedRequest))
    }
}
