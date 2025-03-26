//
//  Environment.swift
//  PeepIt
//
//  Created by 김민 on 3/10/25.
//

import Foundation

/// Environment: 네트워크 설정에 필요한 값들 정의
struct Environment {

    static let baseURL = (
        Bundle.main.infoDictionary?["BASE_URL"] as! String
    ).replacingOccurrences(of: " ", with: "")
}
