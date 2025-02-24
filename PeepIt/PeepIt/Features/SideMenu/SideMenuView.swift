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
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Image("LogoIcon")
                            .frame(width: 57, height: 57)
                        Spacer()
                    }
                    .padding(.top, 126)
                    .padding(.bottom, 70)

                    VStack(spacing: 32) {
                        ForEach(SideMenuType.allCases, id: \.self) { menu in
                            if menu == .notification {
                                MenuView(menuType: menu)
                                    .onTapGesture {
                                        store.send(.notificationMenuTapped)
                                    }
                            } else {
                                NavigationLink(
                                    state: menu.destinationState()
                                ) {
                                    MenuView(menuType: menu)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 186)

                    Group {
                        versionLabel
                            .padding(.bottom, 12)

                        goToAppStoreButton
                            .padding(.bottom, 22)

                        divideView
                            .padding(.bottom, 22)

                        HStack {
                            logoutButton
                            Spacer()
                            settingButton
                        }
                        .frame(height: 29.4)
                    }
                    .padding(.trailing, 15.6)

                    Spacer()
                }
                .padding(.leading, 16)
                .ignoresSafeArea(.all, edges: .bottom)
                .toolbar(.hidden, for: .navigationBar)
                .frame(width: 318)
                .background(Color.base)

                Spacer()
            }
        }
    }

    private var divideView: some View {
        Rectangle()
            .foregroundStyle(Color.op)
            .frame(maxWidth: .infinity)
            .frame(height: 1)
    }

    private var logoutButton: some View {
        Button {
            store.send(.logoutButtonTapped)
        } label: {
            HStack(spacing: 3) {
                Image("LogoutN")
                Text("로그아웃")
            }
            .foregroundStyle(Color.white)
            .pretendard(.body02)
        }
    }

    private var settingButton: some View {
        NavigationLink(
            state: RootStore.Path.State.setting(SettingStore.State())
        ) {
            Image("SettingN")
        }
    }

    private var goToAppStoreButton: some View {
        let button = HStack(spacing: 2) {
            Text("[핍잇이 마음에 드시나요?](https://www.apple.com)") // TODO: 변경
                .pretendard(.caption02)

            Image("IconLink")
                .resizable()
                .frame(width: 20, height: 20)
        }

        return Button {
            // TODO: 
        } label: {
            button.hidden()
        }
        .buttonStyle(
            PressableViewButtonStyle(
                normalView: button.tint(Color.coreLime),
                pressedView: button.tint(Color.coreLimeClick)
            )
        )
    }

    private var versionLabel: some View {
        Text("ver 0.0.0")
            .pretendard(.body03)
            .foregroundStyle(Color.gray300)
    }
}

fileprivate struct MenuView: View {
    let menuType: SideMenuType

    var body: some View {
        HStack {
            Text(menuType.title)
                .pretendard(.title02)
                .foregroundStyle(Color.white)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }
}

#Preview {
    SideMenuView(
        store: .init(initialState: SideMenuStore.State()) {
                SideMenuStore()
            }
    )
}
