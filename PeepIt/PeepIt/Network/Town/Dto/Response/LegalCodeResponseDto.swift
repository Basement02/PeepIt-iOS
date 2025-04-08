//
//  LegalCodeResponseDto.swift
//  PeepIt
//
//  Created by 김민 on 4/8/25.
//

import Foundation

struct LegalCodeResponseDto: Decodable {
    let meta: Meta
    let documents: [RegionDocument]
}

struct Meta: Decodable {
    let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
    }
}

struct RegionDocument: Decodable {
    let regionType: String
    let code: String
    let addressName: String
    let region1DepthName: String
    let region2DepthName: String
    let region3DepthName: String
    let region4DepthName: String
    let x: Double
    let y: Double

    enum CodingKeys: String, CodingKey {
        case regionType = "region_type"
        case code
        case addressName = "address_name"
        case region1DepthName = "region_1depth_name"
        case region2DepthName = "region_2depth_name"
        case region3DepthName = "region_3depth_name"
        case region4DepthName = "region_4depth_name"
        case x
        case y
    }
}


extension LegalCodeResponseDto {

    func toLegalCode() -> LegalCode? {
        guard let code = documents.first(where: { $0.regionType == "B" })?.code else {
            return nil
        }

        return LegalCode(code: code)
    }
}
