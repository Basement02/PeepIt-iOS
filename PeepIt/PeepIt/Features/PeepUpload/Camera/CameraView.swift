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
                Group {
                    Color.white // TODO: 이미지로 변경

                    BackImageLayer.primary()

                    BackImageLayer.secondary()
                }
                .ignoresSafeArea()

                VStack {
                    topBar

                    Spacer()

                    Button {

                    } label: {
                        Image("BtnShot")
                    }
                    .padding(.bottom, 34.adjustedH)
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }

    private var topBar: some View {
        ZStack {
            HStack {
                BackButton {
                    // TODO:
                }
                Spacer()
            }

            Image("FlashOnN")
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    CameraView(
        store: .init(initialState: CameraStore.State()) { CameraStore() }
    )
}
