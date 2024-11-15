//
//  WelcomeView.swift
//  PeepIt
//
//  Created by 김민 on 10/1/24.
//

import SwiftUI
import ComposableArchitecture

struct WelcomeView: View {
    let store: StoreOf<WelcomeStore>

    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {

                title
                    .padding(.leading, 20.adjustedH)
                    .padding(.top, 126.adjustedH)
                    .padding(.bottom, 62.adjustedH)

                detailInfoView

                nicknameView

                Spacer()

                goHomeButton
                    .padding(.bottom, 84.adjustedH)
            }
            .toolbar(.hidden, for: .navigationBar)
            .ignoresSafeArea(.all, edges: .bottom)
            .background(Color.base)
        }
    }

    private var title: some View {
        HStack {
            Text("환영합니다!\n서비스 가입이 완료되었어요.")
                .pretendard(.title02)
                .multilineTextAlignment(.leading)

            Spacer()
        }
    }

    private var dismissButton: some View {
        Button {
            store.send(.goToHomeButtonTapped)
        } label: {
            Image("CloseN")
        }
    }

    private var detailInfoView: some View {
        VStack(spacing: 0) {
            Image("ProfileSample")

            Button {
                // TODO: 프로필 이미지
            } label: {
                Text("수정")
                    .underline()
                    .pretendard(.caption01)
                    .frame(width: 43, height: 44)
                    .foregroundStyle(Color.white)
            }
        }
    }

    private var nicknameView: some View {
        VStack(spacing: 10) {
            Text("${닉네임}")
                .pretendard(.title02)

            Text("@shinhr1115")
                .pretendard(.body02)

            if store.isAuthorized { authLabel }
        }
    }

    private var goHomeButton: some View {
        Button {
            store.send(.goToHomeButtonTapped)
        } label: {
            Text("홈으로")
                .mainLimeButtonStyle()
        }
    }

    private var authLabel: some View {
        HStack(spacing: 0) {
            Image("IconSafety")
            Text("인증 완료")
                .pretendard(.caption04)
                .foregroundStyle(Color.coreLime)
        }
        .padding(.leading, 8)
        .padding(.trailing, 12)
        .padding(.vertical, 3.2)
        .background(
            RoundedRectangle(cornerRadius: 80)
                .stroke(Color.coreLime, lineWidth: 1.0)
                .foregroundStyle(.clear)
        )
    }
}

#Preview {
    NavigationStack {
        WelcomeView(
            store: .init(initialState: WelcomeStore.State()) { WelcomeStore() }
        )
    }
}
