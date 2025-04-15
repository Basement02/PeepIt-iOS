//
//  AsyncProfile.swift
//  PeepIt
//
//  Created by 김민 on 4/15/25.
//

import SwiftUI

struct AsyncProfile: View {
    let profileUrlStr: String?

    var body: some View {
        if let str = profileUrlStr, let url = URL(string: str) {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Image("ProfileSample")
                    .resizable()
            }
        } else {
            Image("ProfileSample")
                .resizable()
        }
    }
}
