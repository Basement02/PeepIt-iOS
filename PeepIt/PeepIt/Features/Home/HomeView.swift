//
//  ContentView.swift
//  PeepIt
//
//  Created by 김민 on 9/12/24.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    var store: StoreOf<HomeStore>

    var body: some View {
        WithPerceptionTracking {
            ZStack {
                HomeMapView()
                    .ignoresSafeArea()

                Group {
                    BackMapLayer.teriary()
                    BackMapLayer.secondary()
                }
                .allowsHitTesting(false)
                .ignoresSafeArea()

                if !store.showTownVeriModal {
                    VStack {
                        topBar
                            .padding(.horizontal, 16)

                        Spacer()

                        HStack(alignment: .bottom) {
                            currentLocationButton
                            Spacer()
                            uploadPeepButton
                        }
                        .padding(.horizontal, 16)
                        .padding(
                            .bottom,
                            PeepModalStore.State.SheetType.scrollUp.height - store.peepPreviewModal.modalOffset + 24
                        )
                    }
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .toolbar(.hidden, for: .navigationBar)
            .overlay {
                TownRegisterModalView(
                    store: store.scope(state: \.townVerification, action: \.townVerification)
                )
                .offset(y: store.townVerificationModalOffset)
                .animation(.easeInOut(duration: 0.3), value: store.townVerificationModalOffset)
            }
            .overlay {
                PeepPreviewModalView(
                    store: store.scope(state: \.peepPreviewModal, action: \.peepPreviewModal)
                )
            }
            .overlay {
                SideMenuView(
                    store: store.scope(state: \.sideMenu, action: \.sideMenu)
                )
            }
        }
    }
}

extension HomeView {
    
    private var topBar: some View {
        HStack {
            moreButton
            
            Spacer()
            
            setMyTownButton
            
            Spacer()
            
            profileButton
        }
        .frame(maxWidth: .infinity)
        .frame(height: 44)
    }
    
    private var moreButton: some View {
        Button {
            store.send(
                .sideMenuButtonTapped, animation: .easeIn(duration: 0.3)
            )
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 13)
                    .fill(Color.blur1)
                    .frame(width: 45, height: 45)
                
                Image("IconMenu")
            }
        }
    }
    
    private var setMyTownButton: some View {
        Button {
            store.send(.addressButtonTapped)
        } label: {
            HStack(spacing: 2) {
                Image("IconLocation")
                
                Text("지금")
                    .pretendard(.body02)
                    .foregroundStyle(Color.white)
                    .padding(.trailing, 3)
                
                Text("동이름")
                    .pretendard(.foodnote)
                    .foregroundStyle(Color.white)
            }
            .padding(.leading, 15)
            .padding(.trailing, 23)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blur1)
                    .frame(height: 45)
            )
        }
    }
    
    private var profileButton: some View {
        Button {
            store.send(.profileButtonTapped)
        } label: {
            Image("ProfileSample")
                .resizable()
                .frame(width: 45, height: 45)
        }
    }
    
    private var currentLocationButton: some View {
        Button {
            // TODO:
        } label: {
            ZStack {
                Circle()
                    .frame(width: 44, height: 44)
                    .hidden()
            }
        }
        .buttonStyle(
            PressableButtonStyle(
                originImg: "AlignBtnN",
                pressedImg: "AlignBtnY"
            )
        )
        .shadowElement()
    }
    
    private var uploadPeepButton: some View {
        Button {
            store.send(.uploadButtonTapped)
        } label: {
            Circle()
                .frame(width: 56, height: 56)
                .hidden()
        }
        .buttonStyle(
            PressableButtonStyle(
                originImg: "PeepBtnN",
                pressedImg: "PeepBtnY"
            )
        )
        .shadowPoint()
    }
}

#Preview {
    HomeView(
        store: .init(initialState: HomeStore.State()) {
            HomeStore()
        }
    )
}

