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

                VStack(spacing: 0) {
                    topBar

                    if store.isRecording {
                        PeepItProgress(store: self.store)
                            .padding(.horizontal, 16)
                            .padding(.top, 10.4.adjustedH)
                    }

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
                    .onEnded {
                        var transaction = Transaction(animation: nil)
                        transaction.disablesAnimations = true
                        store.send(.shootButtonTapped, transaction: transaction)
                    }
            )
            .gesture(
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

fileprivate struct PeepItProgress: View {
    let store: StoreOf<CameraStore>

    var body: some View {
        WithPerceptionTracking {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 100)
                    .fill(Color.nonOp)

                RoundedRectangle(cornerRadius: 100)
                    .fill(Color.coreLime)
                    .frame(width: CGFloat(store.recordingTime) / 30.0 * Constant.screenWidth)
                    .animation(.linear(duration: 1.0), value: store.recordingTime)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 3)
        }
    }
}

#Preview {
    CameraView(
        store: .init(initialState: CameraStore.State()) { CameraStore() }
    )
}
