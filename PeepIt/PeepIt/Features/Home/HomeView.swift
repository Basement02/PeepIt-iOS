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
                Color.white
                    .ignoresSafeArea()

                VStack {
                    topBar
                        .padding(.horizontal, 16.adjustedW)

                    Spacer()

                    HStack {
                        currentLocationButton
                        Spacer()
                        uploadPeepButton
                    }
                    .padding(.horizontal, 16.adjustedW)
                    .padding(
                        .bottom, store.peepPreviewModal.sheetHeight + 24
                    )
                }

                peepPreviewView

                SideMenuView(
                    store: store.scope(state: \.sideMenu, action: \.sideMenu)
                )

                if store.isPeepDetailShowed {
                    PeepDetailView(
                        store: store.scope(state: \.peepDetail, action: \.peepDetail)
                    )
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .toolbar(.hidden, for: .navigationBar)
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
            // TODO: 모달 올리기
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

        } label: {
            ZStack {
                Circle()
                    .frame(width: 44, height: 44)
                    .foregroundStyle(Color.base)
                    .shadowElement()

                Image("IconCurrentLocation")
            }
        }
    }

    private var uploadPeepButton: some View {
        Button {
            store.send(.uploadButtonTapped)
        } label: {
            ZStack {
                Circle()
                    .fill(Color.coreLime)
                    .frame(width: 56, height: 56)
                    .shadowPoint()
                
                Image("IconSubtract")
            }
        }
    }

    private var peepPreviewView: some View {
        GeometryReader { proxy in
            WithPerceptionTracking {
                let height = proxy
                    .frame(in: .global)
                    .height

                PeepPreviewModalView(
                    store: store.scope(state: \.peepPreviewModal, action: \.peepPreviewModal)
                )
                .offset(y: height - SheetType.scrollDown.height)
                .offset(y: store.peepPreviewModal.offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            store.send(
                                .peepPreviewModal(.modalDragged(dragHeight: value.translation.height))
                            )
                        }
                        .onEnded { _ in
                            store.send(.peepPreviewModal(.modalDragEnded))
                        }
                )
                .onAppear {
                    store.send(
                        .peepPreviewModal(.setSheetHeight(height: SheetType.scrollDown.height))
                    )
                }
            }
        }
    }
}

enum SheetType: CaseIterable {
    case scrollDown, scrollUp

    var height: CGFloat {
        switch self {
        case .scrollDown:
            return CGFloat(100)
        case .scrollUp:
            return CGFloat(457)
        }
    }
}

#Preview {
    HomeView(
        store: .init(initialState: HomeStore.State()) {
            HomeStore()
        }
    )
}

