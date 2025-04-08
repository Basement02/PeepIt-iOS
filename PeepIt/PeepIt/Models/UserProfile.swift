//
//  UserProfile.swift
//  PeepIt
//
//  Created by 김민 on 4/8/25.
//

import Foundation

struct UserProfile: Equatable {
    var id: String
    var name: String
    var town: String?
    var profile: String
    var gender: GenderType
    var isCertificated: Bool
}
