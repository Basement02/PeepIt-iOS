//
//  CameraStore.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import Foundation
import ComposableArchitecture
import AVFoundation
import UIKit

@Reducer
struct CameraStore {

    @ObservableState
    struct State: Equatable {
        /// 카메라 세션
        var cameraSession: AVCaptureSession? = nil
        /// 촬영한 사진
        var capturedPhoto: UIImage? = nil
        /// 촬영한 영상
        var recordedVideo: URL? = nil
        /// 영상 촬영 중인지 여부 -> 버튼 모양 및 영상 촬영 시간 체크
        var isRecording = false
        /// 영상 촬영 시간
        var recordingTime = 0
        /// 플래시 기능
        var isFlashOn = false
    }

    enum Action {
        /// 화면 등장 - 카메라 세팅
        case onAppear
        /// 사진, 영상 촬영 관련 뷰에서 발생한 이벤트
        case shootButtonTapped
        case shootButtonLongerTapStarted
        case shootButtonLongerTapEnded
        case flashButtonTapped
        case zoomGestureOnChanged(value: CGFloat)
        /// 영상 촬영
        case stopRecording
        case startRecording
        /// 촬영된 비디오/영상 저장
        case photoCaptured(image: UIImage?)
        case videoRecorded(video: URL?)
        /// 타이머
        case setTimer
        case timerTicked
        /// 화면 전환
        case backButtonTapped
        case pushToEdit(image: UIImage?, video: URL?)
    }

    enum CancelId {
        case timer
    }

    @Dependency(\.dismiss) var dismiss
    @Dependency(\.cameraService) var cameraService

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {

            case .onAppear:
                state.cameraSession = cameraService.startSession()
                return .none

            case .shootButtonTapped:
                let isFlashOn = state.isFlashOn

                return .run { send in
                    do {
                        let data = try await cameraService.capture(with: isFlashOn)
                        await send(.photoCaptured(image: UIImage(data: data)))

                    } catch {
                        print("Photo capture failed: \(error.localizedDescription)")
                    }
                }

            case .shootButtonLongerTapStarted:
                guard !state.isRecording else { return .none }

                state.isRecording = true

                return .merge(
                    .send(.setTimer),
                    .send(.startRecording)
                )

            case .shootButtonLongerTapEnded:
                state.isRecording = false
                state.recordingTime = 0

                return .merge(
                    .cancel(id: CancelId.timer),
                    .send(.stopRecording)
                )

            case .flashButtonTapped:
                state.isFlashOn.toggle()
                return .none

            case let .zoomGestureOnChanged(value):
                return .run { _ in cameraService.setZoom(value) }

            case .startRecording:
                let isFlashOn = state.isFlashOn
                
                return .run { _ in
                    do {
                        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(UUID()).mp4")
                        try cameraService.startRecording(to: outputURL, with: isFlashOn)
                        print("Recording started")
                    } catch {
                        print("Failed to start recording: \(error)")
                    }
                }

            case .stopRecording:
                return .run { send in
                    do {
                        let recordedURL = try await cameraService.stopRecording()
                        print("Recording saved at: \(recordedURL)")
                        await send(.videoRecorded(video: recordedURL))
                    } catch {
                        print("Failed Stop Recording: \(error)")
                    }
                }

            case let .photoCaptured(image):
                state.capturedPhoto = image
                return .send(.pushToEdit(image: image, video: nil))

            case let .videoRecorded(url):
                state.recordedVideo = url
                return .send(.pushToEdit(image: nil, video: url))

            case .setTimer:
                if state.isRecording {
                    return .run { send in
                        await send(.timerTicked)

                        while true {
                            try await Task.sleep(for: .seconds(1))
                            await send(.timerTicked)
                        }
                    }
                    .cancellable(id: CancelId.timer)
                }

                return .none

            case .timerTicked:
                state.recordingTime += 1
                return .none

            case .pushToEdit:
                return .none

            case .backButtonTapped:
                return .run { _ in
                    await dismiss()
                }
            }
        }
    }
}
