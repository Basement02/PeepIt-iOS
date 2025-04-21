//
//  UserProfile.swift
//  PeepIt
//
//  Created by 김민 on 4/8/25.
//

import Foundation

struct UserProfile: Equatable, Codable {
    var id: String
    var name: String
    var townInfo: TownInfo?
    var profile: String
    var gender: GenderType
    var isCertificated: Bool
    var isAgree: Bool
}
