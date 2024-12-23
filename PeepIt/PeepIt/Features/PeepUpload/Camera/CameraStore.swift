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
        case pushToEdit
    }

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
                state.isRecording = true

                return .run { _ in
                    do {
                        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("video.mp4")
                        try cameraService.startRecording(to: outputURL)
                        print("Recording started...")
                    } catch {
                        print("Failed to start recording: \(error)")
                    }
                }

            case .shootButtonLongerTapEnded:
                state.isRecording = false

                return .run { _ in
                    Task {
                        do {
                            let recordedURL = try await cameraService.stopRecording()
                            print("Recording saved at: \(recordedURL)")
                        } catch {
                            print("Failed to stop recording: \(error)")
                        }
                    }
                }

            case let .photoCaptured(image):
                state.capturedPhoto = image
                return .send(.pushToEdit)

            case let .videoRecorded(video):
                state.recordedVideo = video
                return .none

            case .pushToEdit:
                return .none
            }
        }
    }
}
