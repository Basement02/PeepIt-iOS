//
//  LoginView.swift
//  PeepIt
//
//  Created by 김민 on 10/1/24.
//

import SwiftUI
import ComposableArchitecture

struct LoginView: View {
    let store: StoreOf<LoginStore>

    var body: some View {
        VStack(spacing: 0) {
            TabView {
                Rectangle()
                    .frame(width: 247, height: 375)
                    .foregroundStyle(Color.init(uiColor: .lightGray))
                    .tag(0)

                Rectangle()
                    .frame(width: 247, height: 375)
                    .foregroundStyle(Color.init(uiColor: .lightGray))
                    .tag(1)

                Rectangle()
                    .frame(width: 247, height: 375)
                    .foregroundStyle(Color.init(uiColor: .lightGray))
                    .tag(2)
            }
            .tabViewStyle(.page)

            // TODO: 로그인 이미지 수정
            ForEach(LoginType.allCases, id: \.self) { type in
                Button {
                    store.send(.loginButtonTapped(type: type))
                } label: {
                    Text("\(type.description)로 계속")
                }
                .peepItRectangleStyle()
                .padding(.bottom, 15)
            }
        }
        .padding(.horizontal, 22)
    }
}

#Preview {
    LoginView(
        store: .init(initialState: LoginStore.State()) { LoginStore() }
    )
}
