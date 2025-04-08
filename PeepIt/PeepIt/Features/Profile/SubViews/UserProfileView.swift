//
//  UserProfileView.swift
//  PeepIt
//
//  Created by 김민 on 9/24/24.
//

import SwiftUI

struct UserProfileView: View {
    let profile: UserInfo
    let isMine: Bool
    let modifyButtonAction: (() -> ())?

    init(
        profile: UserInfo,
        isMine: Bool = false,
        modifyButtonAction: (() -> Void)? = nil) {
        self.profile = profile
        self.isMine = isMine
        self.modifyButtonAction = modifyButtonAction
    }

    var body: some View {
        VStack(spacing: 0) {
            Image("ProfileSample")
                .frame(width: 91.2, height: 91.2)
                .padding(.bottom, 26.adjustedH)

            info
        }
    }

    private var info: some View {
        VStack(spacing: 4) {
            ZStack {
                Text(profile.nickname)
                    .pretendard(.title02)

                HStack {
                    Spacer()

                    if isMine {
                        Button {
                            modifyButtonAction?()
                        } label: {
                            Text("편집")
                                .pretendard(.caption04)
                                .underline()
                                .foregroundStyle(Color.white)
                                .frame(width: 44, height: 44)
                        }
                    }
                }
            }

            HStack(spacing: 2) {
                Image("IconLocation")
                    .resizable()
                    .frame(width: 22.4, height: 22.4)
                Text("동이름")
                    .pretendard(.body02)
            }
            .padding(.bottom, 7)
        }
    }
}

#Preview {
    UserProfileView(
        profile: .stubUser1,
        isMine: true
    )
}
