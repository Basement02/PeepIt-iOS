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
                Text("환영합니다!\n서비스 가입이 완료되었어요.")
                    .multilineTextAlignment(.center)
                    .padding(.top, 48)

                Spacer()

                Circle()
                    .frame(width: 117, height: 117)
                    .padding(.bottom, 37)

                Text("닉네임")
                    .padding(.bottom, 8)

                Text("아이디")
                    .padding(.bottom, 18)

                if store.isAuthorized { authLabel }

                Spacer()

                goHomeButton
                    .padding(.bottom, 17)
            }
            .padding(.horizontal, 23)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    dismissButton
                }
            }
        }
    }

    private var dismissButton: some View {
        Button {
            store.send(.goToHomeButtonTapped)
        } label: {
            Text("닫기")
        }
    }

    private var goHomeButton: some View {
        Button {
            store.send(.goToHomeButtonTapped)
        } label: {
            Text("서비스 홈으로 이동")
        }
        .peepItRectangleStyle()
    }

    private var authLabel: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
            Text("인증된 회원")
        }
        .background(
            RoundedRectangle(cornerRadius: 100)
                .stroke(.black, lineWidth: 1.0)
                .frame(width: 141, height: 30)
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
