//
//  TownRegisterModalView.swift
//  PeepIt
//
//  Created by 김민 on 2/3/25.
//

import SwiftUI
import ComposableArchitecture

struct TownRegisterModalView: View {
    @Perception.Bindable var store: StoreOf<TownVerificationStore>

    var body: some View {
        WithPerceptionTracking {
            ZStack(alignment: .bottom) {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture { store.send(.viewTapped) }

                VStack {
                    Spacer()

                    Color.base
                        .roundedCorner(20, corners: [.topLeft, .topRight])
                        .overlay {
                            VStack(spacing: 0) {
                                scrollIndicator
                                    .padding(.top, 10)
                                    .padding(.bottom, 41)

                                townLabel
                                    .padding(.bottom, 26)

                                Text("현재 설정된 동네")
                                    .pretendard(.body04)
                                    .foregroundStyle(Color.gray300)
                                    .padding(.bottom, 20)

                                ZStack {
//                                    MapView(centerLoc: .constant(.init(x: 0, y: 0)))
                                    Rectangle()
                                    BackMapLayer.secondary()
                                }
                                .frame(width: 356, height: 369)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .padding(.bottom, 57)

                                Text("새로운 동네를 인증하시겠어요?")
                                    .pretendard(.body04)
                                    .padding(.bottom, 20)

                                registerButton

                                Spacer()
                            }
                        }
                        .frame(height: 775)
                }
                .frame(height: Constant.screenHeight)
            }
            .ignoresSafeArea()
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.height > 0 {
                            store.send(
                                .modalDragOnChanged(height: value.translation.height)
                            )
                        }
                    }
                    .onEnded { value in
                        if value.translation.height > 100 {
                            store.send(.closeModal)
                        } else {
                            store.send(.modalDragOnChanged(height: 0))
                        }
                    }
            )
            .fullScreenCover(isPresented: $store.isSheetVisible) {
                TownVerificationView(store: self.store)
            }
            .transaction({ transaction in
                transaction.disablesAnimations = true
            })
        }
    }

    private var scrollIndicator: some View {
        RoundedRectangle(cornerRadius: 100)
            .fill(Color.gray600)
            .frame(width: 60, height: 5)
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

    private var registerButton: some View {
        Button {
            store.send(.registerButtonTapped)
        } label: {
            Text("동네 등록하기")
                .mainButtonStyle()
                .foregroundStyle(Color.white)
        }
        .buttonStyle(PressableButtonStyle(colorStyle: .gray900))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    TownRegisterModalView(
        store: .init(initialState: TownVerificationStore.State()) {
            TownVerificationStore()
        }
    )
}
