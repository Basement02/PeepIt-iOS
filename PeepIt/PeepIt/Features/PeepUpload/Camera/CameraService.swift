//
//  CameraService.swift
//  PeepIt
//
//  Created by 김민 on 12/23/24.
//

import AVFoundation
import UIKit

protocol CameraServiceProtocol {
    func startSession() -> AVCaptureSession
    func capture(with flashMode: Bool) async throws -> Data
    func startRecording(to url: URL, with flashMode: Bool) throws
    func stopRecording() async throws -> URL
}

final class CameraService: NSObject, CameraServiceProtocol, AVCapturePhotoCaptureDelegate, AVCaptureFileOutputRecordingDelegate {

    private let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private let videoOutput = AVCaptureMovieFileOutput()
    private var continuation: CheckedContinuation<Data, Error>?
    private var videoContinuation: CheckedContinuation<URL, Error>?
    private var currentCamera: AVCaptureDevice?

    func startSession() -> AVCaptureSession {
        session.beginConfiguration()

        session.inputs.forEach { session.removeInput($0) }

        guard let camera = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .back
        ),
            let input = try? AVCaptureDeviceInput(device: camera) else {
            session.commitConfiguration()
            return session
        }

        currentCamera = camera

        guard let microphone = AVCaptureDevice.default(for: .audio),
              let audioInput = try? AVCaptureDeviceInput(device: microphone) else {
            session.commitConfiguration()
            return session
        }

        session.sessionPreset = .hd1920x1080

        if session.canAddInput(input) { session.addInput(input) }
        if session.canAddInput(audioInput) { session.addInput(audioInput) }
        if session.canAddOutput(photoOutput) { session.addOutput(photoOutput) }
        if session.canAddOutput(videoOutput) { session.addOutput(videoOutput) }

        session.commitConfiguration()

        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
        }

        return session
    }

    func capture(with flashMode: Bool) async throws -> Data {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = flashMode ? .on : .off

        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            self.photoOutput.capturePhoto(with: settings, delegate: self)
        }
    }

    func startRecording(to url: URL, with flashMode: Bool) throws {
        guard !videoOutput.isRecording else {
            throw NSError(
                domain: "CameraService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Already recording"]
            )
        }

        guard let camera = currentCamera, camera.hasTorch else { return }

        do {
            try camera.lockForConfiguration()
            camera.torchMode = flashMode ? .on : .off
            camera.unlockForConfiguration()
        } catch {
            print("torch setting failed: \(error.localizedDescription)")
        }

        videoOutput.startRecording(to: url, recordingDelegate: self)
    }

    func stopRecording() async throws -> URL {
        guard videoOutput.isRecording else {
            throw NSError(
                domain: "CameraService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Not currently recording"]
            )
        }

        return try await withCheckedThrowingContinuation { continuation in
            self.videoContinuation = continuation
            videoOutput.stopRecording()

            if let camera = currentCamera, camera.hasTorch {
                do {
                    try camera.lockForConfiguration()
                    camera.torchMode = .off
                    camera.unlockForConfiguration()
                } catch {
                    print("torch setting failed: \(error.localizedDescription)")
                }
            }
        }
    }

    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        if let error = error {
            continuation?.resume(throwing: error)
        } else if let data = photo.fileDataRepresentation() {
            continuation?.resume(returning: data)
        } else {
            continuation?.resume(
                throwing: NSError(
                    domain: "CameraService",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Unknown error"]
                )
            )
        }

        continuation = nil
    }

    func fileOutput(
        _ output: AVCaptureFileOutput,
        didFinishRecordingTo outputFileURL: URL,
        from connections: [AVCaptureConnection],
        error: Error?
    ) {
        if let error = error {
            videoContinuation?.resume(throwing: error)
        } else {
            videoContinuation?.resume(returning: outputFileURL)
        }
        videoContinuation = nil
    }
}
