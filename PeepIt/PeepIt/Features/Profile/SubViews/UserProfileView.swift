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
        VStack(spacing: 0) {
            Image("ProfileSample")
                .frame(width: 91.2, height: 91.2)
                .padding(.bottom, 33.adjustedH)

            Text(profile.nickname)
                .pretendard(.title02)
                .padding(.bottom, 11.adjustedH)

            HStack(spacing: 2) {
                Image("IconLocation")
                    .resizable()
                    .frame(width: 22.4, height: 22.4)

                Text("동이름")
                    .pretendard(.body02)
            }
        }
    }
}

#Preview {
    UserProfileView(profile: .stubUser1)
}
