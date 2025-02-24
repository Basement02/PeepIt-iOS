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
                HomeMapView()
                    .ignoresSafeArea()

                Group {
                    BackMapLayer.secondary()
                    PolygonLayer()
                }
                .ignoresSafeArea()
                .allowsHitTesting(false)

                VStack(spacing: 0) {
                    topBar
                        .padding(.bottom, 73)

                    townLabel

                    Spacer()

                    toCurrentLocationButton
                        .padding(.bottom, 20)

                    verifyButton
                        .padding(.bottom, 84)
                }
                .ignoresSafeArea(.all, edges: .bottom)
            }
        }
    }

    private var topBar: some View {
        ZStack {
            HStack {
                Button {
                    store.send(.backButtonTapped)
                } label: {
                    Image("IconBack")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundStyle(Color.base)
                        .frame(width: 33.6, height: 33.6)
                }

                Spacer()
            }

            Text("지금 나의 위치")
                .pretendard(.subhead)
                .foregroundStyle(Color.base)

            HStack {
                Spacer()
                Button {
                    store.send(.dismissButtonTapped)
                } label: {
                    Image("IconClose")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundStyle(Color.base)
                        .frame(width: 33.6, height: 33.6)
                }
            }
        }
        .frame(height: 44)
        .padding(.horizontal, 16)
    }

    private var townLabel: some View {
        HStack(spacing: 0) {
            Image("IconLocation")
                .resizable()
                .frame(width: 33.6, height: 33.6)
                .padding(.leading, 25)

            Text("OO구 OO동")
                .pretendard(.title03)

            Spacer()
        }
        .frame(width: 181, height: 52)
        .background(
            BackdropBlurView(bgColor: .blur1, radius: 10)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
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
        Text("현재 위치로 인증하기")
            .mainGrayButtonStyle()
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
