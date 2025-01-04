//
//  CameraView.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import SwiftUI
import ComposableArchitecture
import AVFoundation

struct CameraView: View {
    let store: StoreOf<CameraStore>

    var body: some View {
        WithPerceptionTracking {
            ZStack {
                /// 카메라 + 기본 레이어
                Group {
                    if let session = store.cameraSession {
                        CameraPreview(session: session)
                    }

                    BackImageLayer.primary()

                    BackImageLayer.secondary()
                }
                .ignoresSafeArea()

                VStack {
                    topBar

                    Spacer()

                    shootButton
                        .padding(.bottom, 34.adjustedH)
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                store.send(.onAppear)
            }
        }
    }

    private var topBar: some View {
        ZStack {
            HStack {
                BackButton { store.send(.backButtonTapped) }
                Spacer()
            }

            Image("FlashOnN")
        }
        .padding(.horizontal, 16)
    }

    private var shootButton: some View {
        Image(store.isRecording ? "BtnShotIng" : "BtnShot")
            .gesture( /// 탭해서 카메라 찍기
                TapGesture()
                    .onEnded { store.send(.shootButtonTapped) }
            )
            .simultaneousGesture( /// 영상 찍기
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        store.send(.shootButtonLongerTapStarted)
                    }
                    .onEnded { _ in
                        store.send(.shootButtonLongerTapEnded)
                    }
            )
    }
}

#Preview {
    CameraView(
        store: .init(initialState: CameraStore.State()) { CameraStore() }
    )
}
