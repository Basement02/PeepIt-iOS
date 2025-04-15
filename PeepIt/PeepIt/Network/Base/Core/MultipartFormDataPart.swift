//
//  MultipartFormDataPart.swift
//  PeepIt
//
//  Created by 김민 on 4/15/25.
//

import Foundation

struct MultipartFormDataPart {
    let name: String
    let data: Data
    let filename: String?
    let mimeType: String?
}
