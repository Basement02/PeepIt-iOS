//
//  LoginView.swift
//  PeepIt
//
//  Created by 김민 on 10/1/24.
//

import SwiftUI
import ComposableArchitecture

struct LoginView: View {
    @Perception.Bindable var store: StoreOf<LoginStore>

    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {

                Spacer()

                onboardingTab
                    .padding(.bottom, 53.adjustedH)

                loginButtons
                    .padding(.bottom, 106.3.adjustedH)
            }
            .ignoresSafeArea()
            .background(Color.base)
        }
    }

    private var onboardingTab: some View {
        VStack(spacing: 27.adjustedH) {
            Text("설레는 여행,\n함께 시작해요!")
                .pretendard(.title02)
                .multilineTextAlignment(.center)

            TabView(selection: $store.currentTab) {
                ForEach(0..<4) { idx in
                    Rectangle()
                        .frame(width: 264.adjustedW)
                        .foregroundStyle(Color.gray900)
                        .tag(idx)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 399.adjustedH)

            pageIndicator(store.currentTab)
        }
    }

    private func pageIndicator(_ currentTab: Int) -> some View {
        HStack(spacing: 3) {
            ForEach(0..<4) { idx in
                RoundedRectangle(cornerRadius: 60)
                    .frame(
                        width: (currentTab == idx ? 21.6 : 12.3).adjustedW,
                        height: 2.7.adjustedH
                    )
                    .foregroundStyle(
                        currentTab == idx
                        ? Color.white : Color.nonOp
                    )
            }
        }
    }

    private var loginButtons: some View {
        HStack(spacing: 21.adjustedW) {
            ForEach(LoginType.allCases, id: \.self) { type in
                Button {
                    store.send(.loginButtonTapped(type: type))
                } label: {
                    Circle()
                        .frame(width: 74.adjustedH, height: 74.adjustedW)
                        .foregroundStyle(Color.gray400)
                }
            }
        }
    }
}

#Preview {
    LoginView(
        store: .init(initialState: LoginStore.State()) { LoginStore() }
    )
}
