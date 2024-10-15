//
//  EditStore.swift
//  PeepIt
//
//  Created by 김민 on 10/13/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct EditStore {

    @ObservableState
    struct State: Equatable {

        var stickers: [StickerItem] = .init()
        var isTextInputMode = false
        var inputText = ""
        var editMode = ViewEditMode.original

        enum ViewEditMode {
            case original
            case textInputMode
            case editMode
        }

        @Presents var stickerModalState: StickerModalStore.State?
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)

        /// 사운드 on/off 버튼 탭
        case soundOnOffButtonTapped

        /// 스티커 추가 버튼 탭
        case stickerButtonTapped

        /// 텍스트 추가 버튼 탭
        case textButtonTapped

        /// 게시 버튼 탭
        case uploadButtonTapped

        /// 스티커 모달 액션
        case stickerListAction(PresentationAction<StickerModalStore.Action>)

        /// 드래그한 스티커 위치 업데이트
        case updateStickerPosition(stickerId: UUID, position: CGPoint)

        /// 드래그한 스티커 확대/축소 스케일 업데이트
        case updateStickerScale(stickerId: UUID, scale: CGFloat)

        /// 텍스트 추가 완료 버튼 탭
        case textInputCompleteButtonTapped
    }

    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in

            switch action {
            case .soundOnOffButtonTapped:
                return .none

            case .stickerButtonTapped:
                state.stickerModalState = .init()
                return .none

            case .textButtonTapped:
                state.editMode = .textInputMode
                return .none

            case .uploadButtonTapped:
                return .none

            case let .stickerListAction(.presented(.stickerSelected(selectedSticker))):
                state.stickers.append(StickerItem(stickerName: selectedSticker.rawValue))
                state.stickerModalState = nil
                return .none

            case let .updateStickerPosition(stickerId, position):
                guard let index = state.stickers.firstIndex(
                    where: { $0.id == stickerId }
                ) else { return .none }

                state.stickers[index].position = position
                state.editMode = .original

                return .none

            case let .updateStickerScale(stickerId, scale):
                guard let index = state.stickers.firstIndex(
                    where: { $0.id == stickerId }
                ) else { return .none }

                state.stickers[index].scale = scale
                state.editMode = .original

                return .none

            case .textInputCompleteButtonTapped:
                state.editMode = .original
                return .none

            default:
                return .none
            }
        }
        .ifLet(\.$stickerModalState, action: \.stickerListAction) {
            StickerModalStore()
        }
    }
}
