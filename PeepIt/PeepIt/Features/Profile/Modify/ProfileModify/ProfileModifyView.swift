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
        WithPerceptionTracking {
            VStack(spacing: 0) {

                PeepItNavigationBar(
                    trailing: DismissButton { store.send(.backButtonTapped) }
                )
                .padding(.bottom, 23)

                profileView
                    .padding(.bottom, 42)

                VStack(spacing: 15) {
                    idLabel
                    nicknameLabel
                    genderLabel
                }
                .frame(width: 279)

                Spacer()
            }
            .background(Color.base)
            .toolbar(.hidden, for: .navigationBar)
            .onAppear { store.send(.onAppear) }
        }
    }

    private var profileView: some View {
        VStack(spacing: 0) {
            AsyncProfile(profileUrlStr: store.profileImgStr)
                .frame(width: 114, height: 114)
                .clipShape(RoundedRectangle(cornerRadius: 21))

            Button {

            } label: {
                Text("수정")
                    .tint(.white)
                    .pretendard(.caption04)
                    .underline()
                    .frame(width: 44, height: 44)
            }
        }
    }

    private var idLabel: some View {
        HStack(spacing: 11) {
            Text("아이디")
                .pretendard(.foodnote)
            Text(store.id)
                .pretendard(.body04)

            Spacer()
        }
        .frame(height: 44)
    }

    private var nicknameLabel: some View {
        HStack(spacing: 11) {
            Text("닉네임")
                .pretendard(.foodnote)
            Text(store.nickname)
                .pretendard(.body04)

            Spacer()

            NavigationLink(
                state: RootStore.Path.State.modifyNickname(self.store.state)
            ) {
                Text("수정")
                    .tint(.white)
                    .pretendard(.caption04)
                    .underline()
                    .frame(width: 44, height: 44)
            }
        }
        .frame(height: 44)
    }

    private var genderLabel: some View {
        HStack(spacing: 23) {
            Text("성별")
                .pretendard(.foodnote)
            Text(store.selectedGender?.title ?? "기타")
                .pretendard(.body04)

            Spacer()

            NavigationLink(
                state: RootStore.Path.State.modifyGender(self.store.state)
            ) {
                Text("수정")
                    .tint(.white)
                    .pretendard(.caption04)
                    .underline()
                    .frame(width: 44, height: 44)
            }
        }
        .frame(height: 44)
    }
}

#Preview {
    NavigationStack {
        ProfileModifyView(
            store: .init(initialState: ProfileModifyStore.State()) { ProfileModifyStore() }
        )
    }
}
