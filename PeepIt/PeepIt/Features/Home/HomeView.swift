//
//  ContentView.swift
//  PeepIt
//
//  Created by 김민 on 9/12/24.
//

import SwiftUI
import ComposableArchitecture

enum SheetType: CaseIterable {
    case scrollDown, scrollUp

    var height: CGFloat {
        switch self {
        case .scrollDown:
            return CGFloat(69)
        case .scrollUp:
            return CGFloat(500)
        }
    }
}

struct HomeView: View {
    let store: StoreOf<HomeStore>

    var body: some View {
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
        }
        .sheet(isPresented: .constant(true)) {
            GeometryReader { geometry in
                PeepPreviewModalView(store: store)
                    .frame(maxWidth: .infinity)
                    .clearModalBackground()
                    .interactiveDismissDisabled()
                    .presentationDetents(
                        Set(SheetType.allCases.map {
                            PresentationDetent.height($0.height)
                        })
                    )
                    .onChange(of: geometry.size.height) { newHeight in
                        store.send(.setSheetHeight(height: newHeight))
                    }
            }
        }
    }
}

extension HomeView {

    private var moreButton: some View {
        Button {

        } label: {
            Rectangle()
                .frame(width: 30, height: 30)
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
                .frame(width: 30, height: 30)
                .foregroundStyle(Color.gray)
        }
    }

    private var currentLocationButton: some View {
        Button {

        } label: {
            Rectangle()
                .frame(width: 30, height: 30)
                .foregroundStyle(Color.gray)
        }
    }

    private var uploadPeepButton: some View {
        Button {

        } label: {
            Rectangle()
                .frame(width: 30, height: 30)
                .foregroundStyle(Color.gray)
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
