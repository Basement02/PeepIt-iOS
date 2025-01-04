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
        var cameraSession: AVCaptureSession? = nil
        var capturedPhoto: UIImage? = nil
        var recordedVideo: URL? = nil
        var isRecording = false
    }

    enum Action {
        case onAppear
        case shootButtonTapped
        case shootButtonLongerTapStarted
        case shootButtonLongerTapEnded
        case photoCaptured(image: UIImage?)
        case videoRecorded(video: URL?)
        case pushToEdit(image: UIImage?)
        case backButtonTapped
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
                return .run { send in
                    do {
                        let data = try await cameraService.capture()
                        await send(.photoCaptured(image: UIImage(data: data)))

                    } catch {
                        print("Photo capture failed: \(error.localizedDescription)")
                    }
                }

            case .shootButtonLongerTapStarted:
                guard !state.isRecording else { return .none }

                state.isRecording = true

                return .run { _ in
                    do {
                        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(UUID()).mp4")
                        try cameraService.startRecording(to: outputURL)
                        print("Recording started")
                    } catch {
                        print("Failed to start recording: \(error)")
                    }
                }

            case .shootButtonLongerTapEnded:
                state.isRecording = false

                return .run { send in
                    let recordedURL = try await cameraService.stopRecording()
                    print("Recording saved at: \(recordedURL)")
                    await send(.videoRecorded(video: recordedURL))
                }

            case let .photoCaptured(image):
                state.capturedPhoto = image
                return .send(.pushToEdit(image: image))

            case let .videoRecorded(url):
                state.recordedVideo = url
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
