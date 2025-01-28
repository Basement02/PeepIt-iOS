//
//  WelcomeStore.swift
//  PeepIt
//
//  Created by 김민 on 10/1/24.
//

import SwiftUI
import PhotosUI
import ComposableArchitecture

@Reducer
struct WelcomeStore {

    @ObservableState
    struct State: Equatable {
        /// 인증 여부
        var isAuthorized = true
        /// PhotoPicker 변수
        var selectedPhotoItem: PhotosPickerItem? = nil
        /// 선택된 프로필 이미지
        var selectedImage: Image? = nil
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        /// 홈으로 버튼 탭
        case goToHomeButtonTapped
        /// 프로필 이미지 선택 시 설정
        case updateSelectedImage(image: Image)
    }

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
                
            case .binding(\.selectedPhotoItem):
                guard let photoItem = state.selectedPhotoItem else { return .none }
                
                return .run { send in
                    if let image = try? await photoItem.loadTransferable(type: Image.self) {
                        await send(.updateSelectedImage(image: image))
                    }
                }

            case .goToHomeButtonTapped:
                return .none

            case let .updateSelectedImage(image):
                state.selectedImage = image
                return .none

            default:
                return .none
            }
        }
    }
}
