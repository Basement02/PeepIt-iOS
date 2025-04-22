//
//  CurrentAddressResponseDto.swift
//  PeepIt
//
//  Created by 김민 on 4/22/25.
//

import Foundation

struct CurrentAddressResponseDto: Decodable {
    let meta: Meta
    let documents: [AddressDocument]
}

struct AddressDocument: Decodable {
    let roadAddress: RoadAddress?
    let address: Address?

    enum CodingKeys: String, CodingKey {
        case roadAddress = "road_address"
        case address
    }
}

struct RoadAddress: Decodable {
    let addressName: String
    let region1DepthName: String
    let region2DepthName: String
    let region3DepthName: String
    let roadName: String
    let undergroundYN: String
    let mainBuildingNo: String
    let subBuildingNo: String
    let buildingName: String
    let zoneNo: String

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case region1DepthName = "region_1depth_name"
        case region2DepthName = "region_2depth_name"
        case region3DepthName = "region_3depth_name"
        case roadName = "road_name"
        case undergroundYN = "underground_yn"
        case mainBuildingNo = "main_building_no"
        case subBuildingNo = "sub_building_no"
        case buildingName = "building_name"
        case zoneNo = "zone_no"
    }
}

struct Address: Decodable {
    let addressName: String
    let region1DepthName: String
    let region2DepthName: String
    let region3DepthName: String
    let mountainYN: String
    let mainAddressNo: String
    let subAddressNo: String
    let zipCode: String?

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case region1DepthName = "region_1depth_name"
        case region2DepthName = "region_2depth_name"
        case region3DepthName = "region_3depth_name"
        case mountainYN = "mountain_yn"
        case mainAddressNo = "main_address_no"
        case subAddressNo = "sub_address_no"
        case zipCode = "zip_code"
    }
}

extension CurrentAddressResponseDto {

    func toLocationInfo() -> CurrentLocationInfo {
        let roadAddress = documents[0].roadAddress
        let address = documents[0].address

//        return .init(
//            postalCode: roadAddress.zoneNo,
//            roadAddress: roadAddress.addressName,
//            roadName: roadAddress.roadName + roadAddress.mainBuildingNo,
//            building: roadAddress.buildingName
//        )
        return .init(
            postalCode: roadAddress?.zoneNo ?? "",
            roadAddress: (roadAddress?.addressName ?? address?.addressName) ?? "",
            roadName: "",
            building: roadAddress?.buildingName ?? ""
        )
    }
}
