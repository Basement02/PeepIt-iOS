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
                Color(UIColor.systemGray6)
                    .ignoresSafeArea()

                VStack {
                    HStack {
                        moreButton
                        Spacer()
                        setMyTownButton
                        Spacer()
                        profileButton
                    }
                    .padding(.horizontal, 17)

                    Spacer()

                    HStack {
                        currentLocationButton
                        Spacer()
                        uploadPeepButton
                    }
                    .padding(.horizontal, 17)
                    .padding(
                        .bottom, store.state.sheetHeight + 17
                    )
                }

                peepPreviewView

                sideMenuView

                if store.isPeepDetailShowed {
                    PeepDetailView(
                        store: store.scope(state: \.peepDetail, action: \.peepDetail)
                    )
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}

extension HomeView {

    private var sideMenuView: some View {
        SideMenuView(
            store: store.scope(state: \.sideMenu, action: \.sideMenu)

        )
        .offset(x: store.sideMenuOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.width <= 0 {
                            store.send(.dragSideMenu(dragWidth: value.translation.width))
                        }
                    }
                    .onEnded { _ in
                        store.send(.dragSideMenuEnded)
                    }
            )
    }

    private var moreButton: some View {
        Button {
            store.send(
                .sideMenuButtonTapped, animation: .easeIn(duration: 0.3)
            )
        } label: {
            Rectangle()
                .frame(width: 39, height: 39)
                .foregroundStyle(Color.gray)
        }
    }

    private var setMyTownButton: some View {
        Button {

        } label: {
            RoundedRectangle(cornerRadius: 100)
                .frame(width: 156, height: 32)
                .foregroundStyle(Color.gray)
        }
    }

    private var profileButton: some View {
        Button {

        } label: {
            Rectangle()
                .frame(width: 39, height: 39)
                .foregroundStyle(Color.gray)
        }
    }

    private var currentLocationButton: some View {
        Button {

        } label: {
            Rectangle()
                .frame(width: 39, height: 39)
                .foregroundStyle(Color.gray)
        }
    }

    private var uploadPeepButton: some View {
        Button {

        } label: {
            Rectangle()
                .frame(width: 39, height: 39)
                .foregroundStyle(Color.gray)
        }
    }

    private var peepPreviewView: some View {
        GeometryReader { proxy in
            WithPerceptionTracking {
                let height = proxy
                    .frame(in: .global)
                    .height

                PeepPreviewModalView(store: self.store)
                    .offset(y: height - SheetType.scrollDown.height)
                    .offset(y: store.state.offset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                store.send(
                                    .modalDragged(dragHeight: value.translation.height)
                                )
                            }
                            .onEnded { _ in
                                store.send(.modalDragEnded)
                            }
                    )
                    .onAppear {
                        store.send(.setSheetHeight(height: SheetType.scrollDown.height))
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
            return CGFloat(84)
        case .scrollUp:
            return CGFloat(509)
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

