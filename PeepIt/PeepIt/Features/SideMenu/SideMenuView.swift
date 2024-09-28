//
//  SideMenuView.swift
//  PeepIt
//
//  Created by 김민 on 9/22/24.
//

import SwiftUI
import ComposableArchitecture

struct SideMenuView: View {
    let store: StoreOf<SideMenuStore>

    var body: some View {
        WithPerceptionTracking {
            ZStack {
                Color.white
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Rectangle()
                            .frame(width: 39, height: 39)
                            .foregroundStyle(Color.gray)
                        Spacer()
                    }
                    .padding(.top, 34)
                    .padding(.bottom, 50)

                    ForEach(SideMenuType.allCases, id: \.self) { menu in
                        MenuView(menuType: menu)
                    }

                    divideView
                        .padding(.top, 13)

                    HStack {
                        logoutButton
                        Spacer()
                        settingButton
                    }
                    .padding(.top, 25)

                    Spacer()

                    goToAppStoreButton
                        .padding(.bottom, 16)

                    versionLabel
                        .padding(.bottom, 24)
                }
                .padding(.horizontal, 17)
            }
            .ignoresSafeArea(.all, edges: .bottom)
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
                            store.send(.dragSideMenu(dragWidth: -Constant.screenWidth))
                        }
                )
        }
    }

    private var divideView: some View {
        Rectangle()
            .foregroundStyle(Color.gray)
            .frame(maxWidth: .infinity)
            .frame(height: 1)
    }

    private var logoutButton: some View {
        Button {
            // TODO: 로그아웃
        } label: {
            RoundedRectangle(cornerRadius: 100)
                .foregroundStyle(Color.gray)
                .frame(width: 141, height: 40)
        }
    }

    private var settingButton: some View {
        Button {
            store.send(.settingButtonTapped)
        } label: {
            Rectangle()
                .frame(width: 39, height: 39)
                .foregroundStyle(Color.gray)
        }
    }

    private var goToAppStoreButton: some View {
        Text("[핍잇이 마음에 드시나요?](https://www.apple.com)") // TODO: 변경
            .font(.system(size: 16))
            .foregroundStyle(Color.gray)
            .underline()
    }

    private var versionLabel: some View {
        Text("v0.0.0")
            .font(.system(size: 14))
            .foregroundStyle(Color.gray)
    }
}

fileprivate struct MenuView: View {
    let menuType: SideMenuType

    var body: some View {
        HStack(spacing: 16) {
            Image(menuType.iconImage)
                .frame(width: 39, height: 39)
                .background(Color.gray)

            Text(menuType.title)
                .font(.system(size: 16, weight: .semibold))

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
    }
}

enum SideMenuType: CaseIterable {
    case townNews
    case myNews
    case serviceNews

    var title: String {
        switch self {
        case .townNews:
            return "동네 소식"
        case .myNews:
            return "내 소식"
        case .serviceNews:
            return "서비스 소식"
        }
    }

    var iconImage: String {
        switch self {
        case .townNews:
            return ""
        case .myNews:
            return ""
        case .serviceNews:
            return ""
        }
    }
}

#Preview {
    SideMenuView(
        store: .init(initialState: SideMenuStore.State()) {
                SideMenuStore()
            }
    )
}
