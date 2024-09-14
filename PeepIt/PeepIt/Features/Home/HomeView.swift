//
//  ContentView.swift
//  PeepIt
//
//  Created by 김민 on 9/12/24.
//

import SwiftUI
import ComposableArchitecture

enum SheetType {
    case fold, unfold

    var height: CGFloat {
        switch self {
        case .fold:
            return CGFloat(60)
        case .unfold:
            return CGFloat(500)
        }
    }
}

struct ContentView: View {
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
                    .bottom, store.state.sheetType.height + 17
                )
            }
        }
        .sheet(isPresented: .constant(true)) {
            PeepPreviewModalView()
                .ignoresSafeArea()
                .frame(maxWidth: .infinity)
                .clearModalBackground()
                .presentationDetents([.height(60), .height(500)])
                .interactiveDismissDisabled()
                .background(GeometryReader { geometry in
                    Color.clear
                        .onChange(of: geometry.size.height) { newHeight in
                            if newHeight == SheetType.fold.height {
                                store.send(.setSheet(isExpanded: false))
                            } else if newHeight == SheetType.unfold.height {
                                store.send(.setSheet(isExpanded: true))
                            }
                        }
                })
        }
    }
}

extension ContentView {

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
    ContentView(
        store: .init(initialState: HomeStore.State()) { HomeStore() }
    )
}
