//
//  EditStore.swift
//  PeepIt
//
//  Created by 김민 on 10/13/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct EditStore {

    @ObservableState
    struct State: Equatable {
        /// 찍은 이미지
        var image: UIImage? = nil
        /// 스티커 저장
        var stickers: [StickerItem] = .init()
        /// 텍스트 저장
        var texts: [TextItem] = .init()
        /// 뷰 편집 모드
        var editMode = ViewEditMode.original
        /// 기존 텍스트가 선택되었을 때
        var selectedText: TextItem?
        /// 현재 입력 중인 text size
        var inputTextSize: CGFloat = 24
        /// 현재 입력 테스트
        var inputText = ""
        /// 현재 입력 테스트 색
        var inputTextColor: Color = .white

        /// slider state 관련
        var sliderState = SliderStore.State()

        /// 편집 모드 - 기본, 텍스트 입력 모드, 편집 모드(스티커, 텍스트 확대 및 드래그)
        enum ViewEditMode {
            case original
            case textInputMode
            case editMode
        }

        /// 스티커 모달 관련
        @Presents var stickerModalState: StickerModalStore.State?

        /// 우측 상단 done 버튼 보여주기 여부
        var isDoneButtonShowed = false
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)

        /// 뒤로가기
        case backButtonTapped
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
        /// 텍스트 색 선택
        case textColorTapped(newColor: Color)
        /// Slider action 관련
        case sliderAction(SliderStore.Action)
        /// 작업 완료
        case doneButtonTapped
        /// 오브젝트 롱탭 제스처 끝
        case objectLongerTapEnded
    }

    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        BindingReducer()

        Scope(state: \.sliderState, action: \.sliderAction) {
            SliderStore()
        }

        Reduce { state, action in

            switch action {

            case .binding(\.inputText):
                return .none

            case .backButtonTapped:
                return .run { _ in
                    await dismiss()
                }

            case .soundOnOffButtonTapped:
                return .none

            case .stickerButtonTapped:
                state.stickerModalState = .init()
                state.isDoneButtonShowed = true
                return .none

            case .textButtonTapped:
                state.editMode = .textInputMode
                return .none

            case .uploadButtonTapped:
                return .none

            case let .stickerListAction(.presented(.stickerSelected(selectedSticker))):
                state.stickers.append(StickerItem(stickerName: selectedSticker))
                state.stickerModalState = nil
                return .send(.doneButtonTapped)

            case .stickerListAction(.dismiss):
                return .send(.doneButtonTapped)

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
                if let selectedTextId = state.selectedText?.id,
                   let index = state.texts.firstIndex(where: { $0.id == selectedTextId }) {
                    state.texts[index].text = state.inputText
                    state.texts[index].scale = state.inputTextSize
                    state.texts[index].color = state.inputTextColor
                } else {
                    let newText: TextItem = .init(
                        text: state.inputText,
                        scale: state.inputTextSize,
                        color: state.inputTextColor
                    )
                    state.texts.append(newText)
                }

                state.inputText = ""
                state.editMode = .original
                state.selectedText = nil
                state.inputTextSize = 24.0
                state.inputTextColor = .white
                state.sliderState.sliderValue = 24.0

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
                guard let text = state.texts.first(
                    where: { $0.id == textId }
                ) else { return .none }

                state.selectedText = text
                state.inputText = text.text
                state.inputTextSize = text.scale
                state.sliderState.sliderValue = text.scale
                state.inputTextColor = text.color
                state.editMode = .textInputMode

                return .none

            case let .textColorTapped(newColor):
                state.inputTextColor = newColor
                return .none

            case .doneButtonTapped:
                state.isDoneButtonShowed = false
                state.editMode = .original
                return .none

            case .objectLongerTapEnded:
                state.editMode = .original
                return .none

            case .sliderAction(.dragSlider):
                state.inputTextSize = state.sliderState.sliderValue
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
