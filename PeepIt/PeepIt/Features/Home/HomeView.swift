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
            GeometryReader { _ in
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
                                VStack(spacing: 0) {
                                    topBar
                                        .padding(.horizontal, 16)

                                    searchThisMapButton
                                        .padding(.top, 15)

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
                                    .animation(.linear(duration: 0.2), value: store.peepPreviewModal.modalOffset)
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
                        if store.showPeepDetail {
                            PeepDetailView(
                                store: store.scope(state: \.peepDetail, action: \.peepDetail)
                            )
                            .matchedGeometryEffect(id: "peep", in: namespace)
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
            Image("IconMenu")
                .padding(.all, 10)
        }
        .buttonStyle(PressableButtonStyle(colorStyle: .base))
        .clipShape(RoundedRectangle(cornerRadius: 13))
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
            .frame(height: 45)
        }
        .buttonStyle(PressableButtonStyle(colorStyle: .base))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var profileButton: some View {
        Button {
            store.send(.profileButtonTapped)
        } label: {
            Image("ProfileSample")
                .resizable()
                .frame(width: 45, height: 45)
        }
        .buttonStyle(PressableOpacityButtonStyle())
        .clipShape(RoundedRectangle(cornerRadius: 13))
    }

    private var searchThisMapButton: some View {
        Button {

        } label: {
            HStack(spacing: 1) {
                Image("IconSearchStar")
                Text("이 동네에서 검색")
                    .pretendard(.body04)
                    .foregroundStyle(Color.base)
            }
            .padding(.leading, 15)
            .padding(.trailing, 20)
            .padding(.vertical, 8)
        }
        .buttonStyle(PressableButtonStyle(colorStyle: .white))
        .clipShape(RoundedRectangle(cornerRadius: 100))
        .shadow(
            color: .base.opacity(0.15),
            radius: 5,
            x: 0,
            y: 4
        )
    }

    private var currentLocationButton: some View {
        Button {
            // TODO:
        } label: {
            Image("IconNavigationTarget")
                .frame(width: 44, height: 44)
        }
        .buttonStyle(PressableButtonStyle(colorStyle: .base))
        .clipShape(Circle())
        .shadow(
            color: Color(hex: 0x202020, alpha: 0.15),
            radius: 5,
            x: 0,
            y: 4
        )
    }
    
    private var uploadPeepButton: some View {
        Button {
            store.send(.uploadButtonTapped)
        } label: {
            Image("PeepUploadSubtract")
                .padding(.all, 13.3)
        }
        .frame(width: 56, height: 56)
        .buttonStyle(PressableButtonStyle(colorStyle: .lime))
        .clipShape(Circle())
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

