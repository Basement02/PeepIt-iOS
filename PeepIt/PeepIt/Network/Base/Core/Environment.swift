//
//  Environment.swift
//  PeepIt
//
//  Created by 김민 on 3/10/25.
//

import Foundation

/// Environment: 네트워크 설정에 필요한 값들 정의
struct Environment {

    /// 기본 URL
    static let baseURL = (
        Bundle.main.infoDictionary?["BASE_URL"] as! String
    ).replacingOccurrences(of: " ", with: "")

    /// 카카오 네이티브 앱 키
    static let kakaoAppKey = (
        Bundle.main.infoDictionary?["KAKAO_APP_KEY"] as! String
    ).replacingOccurrences(of: " ", with: "")

    static let kakaoRestAPIKey = (
        Bundle.main.infoDictionary?["KAKAO_REST_API_KEY"] as! String
    ).replacingOccurrences(of: " ", with: "")
}
