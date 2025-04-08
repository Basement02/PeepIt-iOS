//
//  WelcomeView.swift
//  PeepIt
//
//  Created by 김민 on 10/1/24.
//

import SwiftUI
import PhotosUI
import ComposableArchitecture

struct WelcomeView: View {
    @Perception.Bindable var store: StoreOf<WelcomeStore>

    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                title
                    .padding(.leading, 20)
                    .padding(.top, 67)
                    .padding(.bottom, 62)

                detailInfoView

                nicknameView

                Spacer()

                if !store.isAuthorized {
                    authToastMessage
                        .padding(.bottom, 20)
                }

                goHomeButton
                    .padding(.bottom, 84)
            }
            .toolbar(.hidden, for: .navigationBar)
            .ignoresSafeArea(.all, edges: .bottom)
            .background(Color.base)
            .onAppear { store.send(.onAppear) }
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

    private var detailInfoView: some View {
        VStack(spacing: 0) {
            Group {
                if let image = store.selectedImage {
                    image
                        .resizable()
                        .scaledToFill()
                } else {
                    Image("ProfileSample")
                        .resizable()
                }
            }
            .frame(width: 91.2, height: 91.2)
            .clipShape(RoundedRectangle(cornerRadius: 20.8))

            PhotosPicker(selection: $store.selectedPhotoItem) {
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
            Text(store.myProfile?.name ?? "")
                .pretendard(.title02)
                .frame(height: 30)

            Text("@\(store.myProfile?.id ?? "")")
                .pretendard(.body02)
                .frame(height: 20)

            if store.isAuthorized {
                authLabel
            }
        }
    }

    private var goHomeButton: some View {
        Button {
            store.send(.goToHomeButtonTapped)
        } label: {
            Text("홈으로")
                .mainButtonStyle()
                .foregroundStyle(Color.gray800)
        }
        .buttonStyle(PressableButtonStyle(colorStyle: .lime))
        .clipShape(RoundedRectangle(cornerRadius: 16))
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
                .stroke(Color.coreLime, lineWidth: 1)
                .foregroundStyle(.clear)
        )
    }

    private var authToastMessage: some View {
        RoundedRectangle(cornerRadius: 100)
            .fill(Color.elevated)
            .frame(width: 293, height: 36)
            .overlay {
                Text("설정에서 언제든 휴대폰 번호를 인증할 수 있어요!")
                    .pretendard(.body04)
            }
    }
}

#Preview {
    NavigationStack {
        WelcomeView(
            store: .init(initialState: WelcomeStore.State()) { WelcomeStore() }
        )
    }
}
