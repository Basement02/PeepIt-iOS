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

    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0

    var body: some View {
        WithPerceptionTracking {
            ZStack {
                /// 카메라 + 기본 레이어
                if let session = store.cameraSession {
                    CameraPreview(session: session)
                        .ignoresSafeArea()
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    let zoomFactor = totalZoom * value
                                    currentZoom = zoomFactor
                                    store.send(
                                        .zoomGestureOnChanged(value: CGFloat(currentZoom))
                                    )
                                }
                                .onEnded { value in
                                    totalZoom = currentZoom
                                }
                        )
                }

                Group {
                    BackImageLayer.primary()
                    BackImageLayer.secondary()
                }
                .ignoresSafeArea()
                .allowsHitTesting(false)

                VStack(spacing: 0) {
                    topBar

                    if store.isRecording {
                        PeepItProgress(store: self.store)
                            .padding(.horizontal, 16)
                            .padding(.top, 10.4)
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
                Button {
                    store.send(.backButtonTapped)
                } label: {
                    Image("IconBackY")
                }
                Spacer()
            }

            Button {
                store.send(.flashButtonTapped)
            } label: {
                Image(store.isFlashOn ? "FlashOnY" : "FlashOffY")
            }
        }
        .padding(.horizontal, 16)
    }

    private var shootButton: some View {
        Image(store.isRecording ? "BtnShotIng" : "BtnShot")
            .onTapGesture {
                if !store.isRecording {
                    store.send(.shootButtonTapped)
                }
            }
            .simultaneousGesture(
                LongPressGesture(minimumDuration: 0.1)
                    .onEnded { _ in
                        if !store.isRecording {
                            store.send(.shootButtonLongerTapStarted)
                        }
                    }
            )
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { _ in
                        if store.isRecording {
                            store.send(.shootButtonLongerTapEnded)
                        }
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
