//
//  ProfileModifyView.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import SwiftUI
import ComposableArchitecture

struct ProfileModifyView: View {
    let store: StoreOf<ProfileModifyStore>

    var body: some View {
        VStack(spacing: 0) {
            Circle()
                .frame(width: 117, height: 117)
                .padding(.vertical, 21)

            modifyProfileButton
                .padding(.bottom, 55)

            idLabel

            nicknameLabel

            genderLabel

            Spacer()
        }
        .padding(.horizontal, 23)
        .toolbar(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButton
            }
        }
    }

    private var backButton: some View {
        Button {

        } label: {
            Text("뒤로")
        }
    }

    private var modifyProfileButton: some View {
        Button {

        } label: {
            Text("프로필 수정")
                .font(.system(size: 12))
                .foregroundStyle(Color.black)
                .background(
                    RoundedRectangle(cornerRadius: 100)
                        .foregroundStyle(Color.init(uiColor: .lightGray))
                        .frame(width: 100, height: 25)
                )
        }
    }

    private var idLabel: some View {
        HStack(spacing: 32) {
            Text("아이디")
            Text(store.id)

            Spacer()
        }
        .padding(.vertical, 22)
        .font(.system(size: 12))
    }

    private var nicknameLabel: some View {
        HStack(spacing: 32) {
            Text("닉네임")
            Text(store.nickname)

            Spacer()

            Image(systemName: "chevron.right")
        }
        .padding(.vertical, 22)
        .font(.system(size: 12))
    }

    private var genderLabel: some View {
        HStack(spacing: 43) {
            Text("성별")
            Text(store.gender.title)

            Spacer()

            Image(systemName: "chevron.right")
        }
        .padding(.vertical, 22)
        .font(.system(size: 12))
    }
}

#Preview {
    NavigationStack {
        ProfileModifyView(
            store: .init(initialState: ProfileModifyStore.State()) { ProfileModifyStore() }
        )
    }
}
