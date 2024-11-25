//
//  WithdrawModal.swift
//  PeepIt
//
//  Created by 김민 on 11/25/24.
//

import SwiftUI
import ComposableArchitecture

struct WithdrawModal: View {
    let store: StoreOf<SettingStore>

    var body: some View {
        WithPerceptionTracking {
            ZStack {
                Color.white

                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(Color.red)
                    .onTapGesture {
                        store.send(
                            .closeSheet,
                            animation: .easeInOut(duration: 0.3)
                        )
                    }
            }
            .ignoresSafeArea()
            .background(Color.blue)
        }
    }
}

#Preview {
    WithdrawModal(
        store: .init(initialState: SettingStore.State()) {
            SettingStore()
        }
    )
}
