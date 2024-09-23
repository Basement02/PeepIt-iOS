//
//  UserProfileView.swift
//  PeepIt
//
//  Created by 김민 on 9/24/24.
//

import SwiftUI

struct UserProfileView: View {
    let profile: UserProfile

    var body: some View {
        HStack(spacing: 20) {
            Circle()
                .frame(width: 97, height: 97)

            VStack(alignment: .leading, spacing: 17) {
                Text("\(profile.nickname)")
                Text("\(profile.town)")
            }

            Spacer()
        }
    }
}

#Preview {
    UserProfileView(profile: .stubUser1)
}
