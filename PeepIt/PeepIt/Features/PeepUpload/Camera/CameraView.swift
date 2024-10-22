//
//  CameraView.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import SwiftUI
import ComposableArchitecture

struct CameraView: View {
    let store: StoreOf<CameraStore>

    var body: some View {
        WithPerceptionTracking {
            ZStack {
                Color.gray

                VStack {
                    Spacer()

                    Button {
                        store.send(.shootButtonTapped)
                    } label: {
                        Circle()
                            .frame(width: 62, height: 62)
                            .foregroundStyle(Color.white)
                    }
                    .padding(.bottom, 66)
                }
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    CameraView(
        store: .init(initialState: CameraStore.State()) { CameraStore() }
    )
}
