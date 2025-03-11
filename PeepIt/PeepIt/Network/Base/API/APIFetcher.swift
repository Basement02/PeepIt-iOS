//
//  APIFetcher.swift
//  PeepIt
//
//  Created by 김민 on 3/11/25.
//

import Foundation
import Alamofire

final class APIFetcher {

    static let shared = APIFetcher()

    private init() { }

    func fetch<T: Decodable>(of api: APIType) async throws -> T {
        let request = createDataRequest(for: api)
        let response = await request.serializingData().response

        guard let httpResponse = response.response,
              let data = response.data else {
            throw NetworkError.noResponse
        }

        do {
            let decodedResponse = try JSONDecoder().decode(BaseResponse<T>.self, from: data)

            if decodedResponse.success,
                let result = decodedResponse.data {
                return result
            }

            if let serverException = decodedResponse.error {
                throw NetworkError.serverError(serverException)
            }

            throw NetworkError.unknown

        } catch let decodingError as DecodingError {
            throw NetworkError.decodingFailed
        } catch {
            throw error
        }
    }
}

extension APIFetcher {

    private func createDataRequest(for endpoint: APIType) -> DataRequest {
        let url = endpoint.baseURL.appendingPathComponent(endpoint.path)
        let interceptor = Interceptor() // TODO: 수정

        switch endpoint.task {

        case .requestPlain:
            return AF.request(
                url,
                method: endpoint.method,
                headers: endpoint.header,
                interceptor: interceptor
            )

        case let .requestJSONEncodable(body):
            return AF.request(
                url,
                method: endpoint.method,
                parameters: body,
                encoder: JSONParameterEncoder.default,
                headers: endpoint.header,
                interceptor: interceptor
            )

        case let .requestParameters(parameters):
            return AF.request(
                url,
                method: endpoint.method,
                parameters: parameters,
                encoding: URLEncoding.queryString,
                headers: endpoint.header,
                interceptor: interceptor
            )

        case let .requestWithoutInterceptor(parameters):
            return AF.request(
                url,
                method: endpoint.method,
                parameters: parameters,
                encoding: URLEncoding.queryString,
                headers: endpoint.header
            )
        }
    }
}
