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

                VStack {
                    Spacer()

                    BackdropBlurView(bgColor: .blur1, radius: 4)
                        .roundedCorner(20, corners: [.topLeft, .topRight])
                        .overlay {
                            VStack(spacing: 0) {
                                RoundedRectangle(cornerRadius: 100)
                                    .fill(Color.gray600)
                                    .frame(width: 60, height: 5)
                                    .padding(.top, 10)
                                    .padding(.bottom, 26)

                                Text("현재 설정된 동네")
                                    .pretendard(.foodnote)
                                    .foregroundStyle(Color.gray300)
                                    .padding(.bottom, 26)

                                HStack(spacing: 0) {
                                    Image("IconLocation")
                                        .resizable()
                                        .frame(width: 33.6, height: 33.6)
                                    Text("OO구 OO동")
                                        .pretendard(.title03)
                                }
                                .frame(width: 181, height: 52)
                                .padding(.bottom, 26)

                                ZStack {
                                    HomeMapView()
                                    BackMapLayer.secondary()
                                    Circle()
                                        .fill(Color.coreLimeOp)
                                        .frame(width: 127, height: 126)
                                    Circle()
                                        .stroke(Color.coreLimeClick, lineWidth: 2)
                                        .frame(width: 127, height: 126)
                                }
                                .frame(width: 327, height: 350)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .padding(.bottom, 67)

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
        }
    }

    private var registerButton: some View {
        Button {
            store.send(.registerButtonTapped)
        } label: {
            Text("동네 등록하기")
                .mainGrayButtonStyle()
        }
    }
}

#Preview {
    TownRegisterModalView(
        store: .init(initialState: TownVerificationStore.State()) {
            TownVerificationStore()
        }
    )
}
