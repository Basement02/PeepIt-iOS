//
//  BlockDescriptionModal.swift
//  PeepIt
//
//  Created by 김민 on 12/17/24.
//

import SwiftUI
import ComposableArchitecture

struct BlockDescriptionModal: View {
    let store: StoreOf<OtherProfileStore>

    var body: some View {
        ZStack {
            BackdropBlurView(bgColor: .base, radius: 1)
                .roundedCorner(20, corners: [.topLeft, .topRight])

            VStack(spacing: 0) {
                slider
                    .padding(.top, 10)
                    .padding(.bottom, 50.21)

                mainView

                Spacer()

                bottomView
                    .padding(.bottom, 38)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.clear)
        .ignoresSafeArea()
    }

    private var slider: some View {
        RoundedRectangle(cornerRadius: 100)
            .frame(width: 60, height: 5)
            .foregroundStyle(Color.gray600)
    }

    private var mainView: some View {
        VStack(alignment: .leading, spacing: 35) {
            Image("ProfileSample")
                .resizable()
                .frame(width: 54, height: 54)

            Text("닉네임님을\n정말 차단하고 싶으신가요?")
                .pretendard(.title02)

            Text("회원 차단 시 어떻게 되나요?")
                .pretendard(.body04)

            infoView
        }
        .frame(width: 335)
    }

    private var infoView: some View {
        HStack {
            Text(
                """
                · 차단한 회원이 게시하는 모든 활동은 나에게 제공되지 않아요.
                
                · 내가 게시하는 모든 활동은 차단한 회원에게 제공되지 않아요.
                
                · 회원 차단 여부는 다른 사람에게 공유되지 않아요.
                
                · 언제든지 설정해서 차단을 해제할 수 있습니다.
                """
            )
            Spacer()
        }
        .pretendard(.caption04)
        .foregroundStyle(Color.init(hex: 0xCFCFCF))
        .padding(.vertical, 22)
        .padding(.leading, 16)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(Color.gray900)
                .frame(width: 335)
        )
    }

    private var bottomView: some View {
        HStack {
            Spacer()
            VStack(spacing: 0) {
                blockButton
                cancelButton
            }
            Spacer()
        }
    }

    private var blockButton: some View {
        Button {
            store.send(.blockUser)
        } label: {
            Text("차단하기")
                .mainButtonStyle()
                .foregroundStyle(Color.white)
        }
        .buttonStyle(PressableButtonStyle(colorStyle: .gray900))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var cancelButton: some View {
        Button {
            store.send(.closeModal)
        } label: {
            Text("취소")
                .pretendard(.caption02)
                .foregroundStyle(Color.white)
                .frame(width: 44, height: 44)
        }
    }
}

#Preview {
    BlockDescriptionModal(
        store: .init(initialState: OtherProfileStore.State()) { OtherProfileStore() }
    )
}
