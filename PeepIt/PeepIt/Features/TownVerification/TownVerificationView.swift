//
//  TownVerificationView.swift
//  PeepIt
//
//  Created by 김민 on 2/3/25.
//

import SwiftUI
import ComposableArchitecture

struct TownVerificationView: View {
    var store: StoreOf<TownVerificationStore>

    var body: some View {
        WithPerceptionTracking {
            ZStack {
                Color.base.ignoresSafeArea()

                VStack(spacing: 0) {
                    PeepItNavigationBar(
                        leading: BackButton { store.send(.backButtonTapped) },
                        title: "동네 등록하기",
                        trailing: DismissButton { store.send(.dismissButtonTapped) }
                    )
                    .padding(.bottom, 30)

                    townLabel
                        .padding(.bottom, 26)

                    Text("지금 나의 위치")
                        .pretendard(.body04)
                        .foregroundStyle(Color.gray300)
                        .padding(.bottom, 20)

                    ZStack(alignment: .bottom) {
                        HomeMapView()
                        BackMapLayer.secondary()
                            .allowsHitTesting(false)
                        toCurrentLocationButton
                            .padding(.bottom, 30)
                    }
                    .frame(width: 356, height: 369)
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                    Spacer()

                    verifyButton
                        .padding(.bottom, 84)
                }
                .ignoresSafeArea(.all, edges: .bottom)
            }
        }
    }

    private var townLabel: some View {
        HStack(spacing: 0) {
            Image("IconLocation")
                .resizable()
                .frame(width: 30, height: 30)
            Text("구/읍면동")
                .pretendard(.foodnote)
        }
        .padding(.vertical, 9)
        .padding(.leading, 25)
        .padding(.trailing, 30)
    }
    

    private var toCurrentLocationButton: some View {
        Button {

        } label: {
            HStack(spacing: 3) {
                Image("IconDirection")
                Text("현재 위치로 돌아가기")
                    .pretendard(.body04)
                    .foregroundStyle(Color.base)
                Spacer()
            }
            .padding(.leading, 23)
            .frame(width: 194, height: 38)
        }
        .buttonStyle(PressableButtonStyle(colorStyle: .white))
        .shadow(
            color: Color(hex: 0x202020, alpha: 0.15),
            radius: 5,
            x: 0,
            y: 4
        )
        .clipShape(RoundedRectangle(cornerRadius: 100))
    }
    

    private var verifyButton: some View {
        Button {
        } label: {
            Text("현재 위치로 인증하기")
                .mainButtonStyle()
                .foregroundStyle(Color.gray800)
        }
        .buttonStyle(PressableButtonStyle(colorStyle: .lime))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(
            color: Color(hex: 0x202020, alpha: 0.15),
            radius: 5,
            x: 0,
            y: 4
        )
    }
}

#Preview {
    TownVerificationView(
        store: .init(initialState: TownVerificationStore.State()) {
            TownVerificationStore()
        }
    )
}
