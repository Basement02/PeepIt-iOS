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

                    Image(store.isRecording ? "BtnShotIng" : "BtnShot")
                        .padding(.bottom, 34.adjustedH)
                        .onTapGesture {
                            var transaction = Transaction(animation: nil)
                            transaction.disablesAnimations = true
                            store.send(.shootButtonTapped, transaction: transaction)
                        }
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
}

#Preview {
    CameraView(
        store: .init(initialState: CameraStore.State()) { CameraStore() }
    )
}
