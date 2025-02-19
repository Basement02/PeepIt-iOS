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

    @Namespace private var namespace

    var body: some View {
        WithPerceptionTracking {
            ZStack {
                Group {
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

                        /// 핍 미리보기 모달
                        PeepPreviewModalView(
                            store: store.scope(state: \.peepPreviewModal, action: \.peepPreviewModal),
                            namespace: namespace
                        )

                        /// 사이드메뉴 등장 시 필터
                        if store.mainViewMoved {
                            Color.blur2
                                .ignoresSafeArea()
                                .onTapGesture { store.send(.dismissSideMenu) }
                        }
                    }
                }
                .offset(x: store.mainViewOffset)

                SideMenuView(
                    store: store.scope(state: \.sideMenu, action: \.sideMenu)
                )
                .offset(x: store.sideMenu.sideMenuOffset)
            }
            .animation(.easeInOut(duration: 0.3), value: store.mainViewOffset)
            .ignoresSafeArea(.all, edges: .bottom)
            .toolbar(.hidden, for: .navigationBar)
            .overlay {
                /// 핍 상세
                if store.showPeepDetail, let idx = store.selectedPeepIndex {
                    PeepDetailView(
                        store: store.scope(state: \.peepDetail, action: \.peepDetail)
                    )
                    .matchedGeometryEffect(id: "peep\(idx)", in: namespace)
                    .transition(.scale(scale: 1))
                }
            }
            .overlay {
                TownRegisterModalView(
                    store: store.scope(state: \.townVerification, action: \.townVerification)
                )
                .offset(y: store.townVerificationModalOffset)
                .animation(.easeInOut(duration: 0.3), value: store.townVerificationModalOffset)
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
            store.send(.sideMenuButtonTapped)
            store.send(
                .showSideMenu, animation: .easeIn(duration: 0.3)
            )
        } label: {
            RoundedRectangle(cornerRadius: 13)
                .fill(Color.blur1)
                .frame(width: 45, height: 45)
                .overlay { Image("IconMenu") }
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
                .clipShape(RoundedRectangle(cornerRadius: 13))
        }
    }
    
    private var currentLocationButton: some View {
        let normal = Circle()
            .fill(Color.base)
            .frame(width: 44, height: 44)

        let pressable = Circle()
            .fill(Color.gray700)
            .frame(width: 44, height: 44)

        return Button {
            // TODO:
        } label: {
            Circle()
                .frame(width: 44, height: 44)
                .hidden()
        }
        .buttonStyle(
            PressableViewButtonStyle(normalView: normal, pressedView: pressable)
        )
        .overlay { Image("IconNavigationTarget") }
        .shadow(
            color: Color(hex: 0x202020, alpha: 0.15),
            radius: 5,
            x: 0,
            y: 4
        )
    }
    
    private var uploadPeepButton: some View {
        let normal = Circle()
            .fill(Color.coreLime)
            .frame(width: 56, height: 56)

        let pressable = Circle()
            .fill(Color.coreLimeClick)
            .frame(width: 56, height: 56)

        return Button {
            store.send(.uploadButtonTapped)
        } label: {
            Circle()
                .frame(width: 56, height: 56)
                .hidden()
        }
        .buttonStyle(
            PressableViewButtonStyle(normalView: normal, pressedView: pressable)
        )
        .overlay {
            Image("IconSubtract")
                .resizable()
                .frame(width: 19, height: 19)
        }
        .shadow(
            color: Color(hex: 0x202020, alpha: 0.15),
            radius: 5,
            x: 0,
            y: 4
        )
    }
}

#Preview {
    HomeView(
        store: .init(initialState: HomeStore.State()) {
            HomeStore()
        }
    )
}

