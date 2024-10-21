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
        
        /// 스티커 저장
        var stickers: [StickerItem] = .init()
        /// 텍스트 저장
        var texts: [TextItem] = .init()
        /// 입력 테스트 바인딩 위함
        var inputText = ""
        /// 뷰 편집 모드
        var editMode = ViewEditMode.original
        /// 선택된 텍스트 아이디(기존 텍스트를 수정할 때)
        var selectedTextId: UUID?

        /// 편집 모드 - 기본, 텍스트 입력 모드, 편집 모드(스티커, 텍스트 확대 및 드래그)
        enum ViewEditMode {
            case original
            case textInputMode
            case editMode
        }

        /// 스티커 모달 관련
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
        /// 스티커 확대/축소 스케일 업데이트
        case updateStickerScale(stickerId: UUID, scale: CGFloat)
        /// 텍스트 추가 완료 버튼 탭
        case textInputCompleteButtonTapped
        /// 텍스트 위치 업데이트
        case updateTextPosition(textId: UUID, position: CGPoint)
        /// 텍스트 확대/축소 스케일 업데이트
        case updateTextScale(textId: UUID, scale: CGFloat)
        /// 텍스트 선택
        case textFieldTapped(textId: UUID)
        /// 텍스트 입력 나타날 때 새로운 텍스트 추가인지, 기존 텍스트인지 판단
        case inputTextFieldAppeared
    }

    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in

            switch action {
            case .binding(\.inputText):
                return .none

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
                if let selectedTextId = state.selectedTextId, 
                    let index = state.texts.firstIndex(where: { $0.id == selectedTextId }) {
                    state.texts[index].text = state.inputText
                } else {
                    let newText: TextItem = .init(text: state.inputText)
                    state.texts.append(newText)
                }

                state.inputText = ""
                state.editMode = .original
                state.selectedTextId = nil

                return .none

            case let .updateTextPosition(textId, position):
                guard let index = state.texts.firstIndex(
                    where: { $0.id == textId }
                ) else { return .none }

                state.texts[index].position = position
                state.editMode = .original

                return .none

            case let .updateTextScale(textId, scale):
                guard let index = state.texts.firstIndex(
                    where: { $0.id == textId }
                ) else { return .none }

                state.texts[index].scale = scale
                state.editMode = .original
                return .none

            case let .textFieldTapped(textId):
                state.selectedTextId = textId
                state.editMode = .textInputMode
                return .none

            case .inputTextFieldAppeared:
                if let selectedTextId = state.selectedTextId,
                   let textItem = state.texts.first(where: { $0.id == selectedTextId }) {
                    state.inputText = textItem.text
                }

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
