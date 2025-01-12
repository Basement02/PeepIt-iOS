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
            VStack(alignment: .leading, spacing: 0) {

                PeepItNavigationBar(trailing: dismissButton)
                    .padding(.bottom, 23.adjustedH)

                HStack {
                    Image("LogoIcon")
                        .frame(width: 57, height: 57)
                    Spacer()
                }
                .padding(.bottom, 70.adjustedH)

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
                .padding(.bottom, 186.adjustedH)

                Group {
                    versionLabel
                        .padding(.bottom, 12.adjustedH)

                    goToAppStoreButton
                        .padding(.bottom, 22.adjustedH)

                    divideView
                        .padding(.bottom, 22.adjustedH)

                    HStack {
                        logoutButton
                        Spacer()
                        settingButton
                    }
                    .frame(height: 29.4)
                }
                .padding(.trailing, 15.6.adjustedW)

                Spacer()
            }
            .padding(.leading, 16.adjustedW)
            .ignoresSafeArea(.all, edges: .bottom)
            .toolbar(.hidden, for: .navigationBar)
            .background(Color.base)
            .offset(x: store.sideMenuOffset)
        }
    }

    private var dismissButton: some View {
        Button {
            store.send(.dismissSideMenu, animation: .none)
        } label: {
            Rectangle()
                .fill(Color.clear)
                .frame(width: 33.6, height: 33.6)
        }
        .buttonStyle(
            PressableButtonStyle(originImg: "CloseN", pressedImg: "CloseY")
        )
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
                    .pretendard(.body02)
            }
            .opacity(0)
        }
        .buttonStyle(
            PressableViewButtonStyle(
                normalView:
                    HStack(spacing: 3) {
                        Image("LogoutN")
                        Text("로그아웃")
                            .pretendard(.body02)
                    },
                pressedView:
                    HStack(spacing: 3) {
                        Image("LogoutY")
                        Text("로그아웃")
                            .pretendard(.body05)
                            .foregroundStyle(Color.gray300)
                }
            )
        )
    }

    private var settingButton: some View {
        NavigationLink(
            state: RootStore.Path.State.setting(SettingStore.State())
        ) {
            Image("SettingN")
        }
    }

    private var goToAppStoreButton: some View {
        HStack(spacing: 2) {
            Text("[핍잇이 마음에 드시나요?](https://www.apple.com)") // TODO: 변경
                .pretendard(.caption02)
                .tint(Color.coreLime)

            Image("IconLink")
        }
    }

    private var versionLabel: some View {
        Text("ver 0.0.0")
            .pretendard(.caption01)
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
