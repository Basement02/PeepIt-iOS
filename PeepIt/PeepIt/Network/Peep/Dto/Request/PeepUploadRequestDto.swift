//
//  PeepUploadRequestDto.swift
//  PeepIt
//
//  Created by 김민 on 4/21/25.
//

import Foundation

struct PeepUploadRequestDto: Encodable {
    let legalDistrictCode: String
    let content: String
    let latitude: Double
    let longitude: Double
    let postalCode: String = "우편번호"
    let roadNameAddress: String = "주소"
    let roadNameCode: String = "도로번호"
    let building: String
    let isVideo: Bool
}
