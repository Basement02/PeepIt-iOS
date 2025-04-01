//
//  LoginView.swift
//  PeepIt
//
//  Created by 김민 on 10/1/24.
//

import AuthenticationServices
import SwiftUI
import ComposableArchitecture

struct LoginView: View {
    @Perception.Bindable var store: StoreOf<LoginStore>

    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {

                Spacer()

                onboardingTab

                loginButtons
                    .padding(.top, 53.adjustedH)

                Spacer()
            }
            .ignoresSafeArea()
            .background(Color.base)
        }
    }

    private var onboardingTab: some View {
        VStack(spacing: 27) {
            Text("설레는 여행,\n함께 시작해요!")
                .pretendard(.title02)
                .multilineTextAlignment(.center)

            TabView(selection: $store.currentTab) {
                ForEach(0..<4) { idx in
                    Rectangle()
                        .frame(width: 261)
                        .foregroundStyle(Color.gray900)
                        .tag(idx)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 399)

            pageIndicator(store.currentTab)
        }
    }

    private func pageIndicator(_ currentTab: Int) -> some View {
        HStack(spacing: 3) {
            ForEach(0..<4) { idx in
                RoundedRectangle(cornerRadius: 60)
                    .frame(
                        width: (currentTab == idx ? 21.6 : 12.3),
                        height: 2.7
                    )
                    .foregroundStyle(
                        currentTab == idx
                        ? Color.white : Color.nonOp
                    )
            }
        }
    }

    private var loginButtons: some View {
        HStack(spacing: 21) {
            ForEach(LoginType.allCases, id: \.self) { type in
                Group {
                    switch type {
                    case .kakao:
                        loginIcon("KakaoLogo")
                            .onTapGesture {
                                store.send(.loginButtonTapped(type: .kakao))
                            }
                    case .naver:
                        loginIcon("NaverLogo")
                            .onTapGesture {
                                store.send(.loginButtonTapped(type: .naver))
                            }
                    case .apple:
                        loginIcon("AppleLogo")
                            .overlay {
                                defaultAppleLoginButton
                                    .frame(width: 140, height: 64)
                                    .scaleEffect(74 / 64) // 기본 애플로그인 버튼 최대 높이 64
                                    .clipShape(Circle())
                                    .contentShape(Circle())
                                    .blendMode(.overlay)
                            }
                    }
                }
            }
        }
    }

    private func loginIcon(_ imageName: String) -> some View {
        Image(imageName)
            .resizable()
            .frame(width: 74, height: 74)
    }

    private var defaultAppleLoginButton: some View {
          SignInWithAppleButton { request in
              store.send(
                .appleLoginAction(.appleLoginRequest(request: request))
              )
          } onCompletion: { result in
              store.send(
                .appleLoginAction(.appleLoginCompletion(result: result))
              )
          }
      }
}

#Preview {
    LoginView(
        store: .init(initialState: LoginStore.State()) { LoginStore() }
    )
}
