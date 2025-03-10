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
        /// 찍은 영상
        var videoURL: URL? = nil
        /// 캡처 위한 이미지 사이즈
        var imageSize: CGSize = .zero
        /// 텍스트 저장
        var texts: [TextItem] = .init()
        /// 뷰 편집 모드
        var editMode = ViewEditMode.original
        /// 기존 텍스트가 선택되었을 때
        var selectedText: TextItem?
        /// 현재 입력 테스트
        var inputText = ""
        /// 캡처 시 back image layer 숨기기 여부
        var isCapturing = false
        /// slider state 관련
        var sliderState = SliderStore.State()
        /// 영상 소리 모드
        var isVideoSoundOn = true
        /// 비디오 재생 여부
        var isVideoPlaying = true
        /// 이미지인지 영상인지 체크
        var dataType = DataType.image
        /// 현재 텍스트 사이즈
        var currentTextSize: CGSize = .zero
        /// 현재 선택된(편집 중인( 텍스트
        var currentTextItem: TextItem? = nil

        /// 편집 모드 - 기본, 텍스트 입력 모드, 편집 모드(스티커, 텍스트 확대 및 드래그)
        enum ViewEditMode {
            case original
            case textInputMode
            case editMode
        }

        /// 데이터 타입 종류(이미지, 영상)
        enum DataType {
            case image
            case video
        }

        /// 스티커 모달 관련
        @Presents var stickerModalState: StickerModalStore.State?
        var stickerState = StickerLayerStore.State()
        var textState = TextLayerStore.State()
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
        /// 현재 편집 중 이미지 렌더링
        case captureImage(image: UIImage?)
        /// 영상 렌더링 완료
        case renderingCompleted(url: URL?)
        /// 스티커 모달 액션
        case stickerListAction(PresentationAction<StickerModalStore.Action>)
        /// 텍스트 추가 완료 버튼 탭
        case textInputCompleteButtonTapped
        /// 텍스트 확대/축소 스케일 업데이트
        case updateTextScale(textId: UUID, scale: CGFloat)
        /// 텍스트 색 선택
        case textColorTapped(newColor: Color)
        /// Slider action 관련
        case sliderAction(SliderStore.Action)
        /// 작업 완료
        case doneButtonTapped
        /// 오브젝트 롱탭 제스처 끝
        case objectLongerTapEnded
        /// 영상 소리 모드에 따른 렌더링
        case renderVideo
        /// 화면 전환
        case pushToWriteBody(image: UIImage?, videoURL: URL?)
        /// 뷰 나타날 때
        case onAppear
        /// 뷰  사라질 때
        case onDisappear
        /// 삭제 영역 계산
        case setDeleteFrame(rect: CGRect)
        /// 자식 뷰 - 스티커 관련
        case stickerAction(StickerLayerStore.Action)
        /// 자식 뷰 - 텍스트 관련
        case textAction(TextLayerStore.Action)
        /// 편집 중인 텍스트 크기 변경
        case setTextSize(size: CGSize)
    }

    @Dependency(\.dismiss) var dismiss
    @Dependency(\.videoRenderService) var videoRenderService

    var body: some Reducer<State, Action> {
        BindingReducer()

        Scope(state: \.sliderState, action: \.sliderAction) {
            SliderStore()
        }

        Scope(state: \.stickerState, action: \.stickerAction) {
            StickerLayerStore()
        }

        Scope(state: \.textState, action: \.textAction) {
            TextLayerStore()
        }

        Reduce { state, action in

            switch action {

            case .binding(\.inputText):
                return .none

            case .backButtonTapped:
                return .run { _ in await dismiss() }

            case .soundOnOffButtonTapped:
                state.isVideoSoundOn.toggle()
                return .none

            case .stickerButtonTapped:
                state.stickerModalState = .init()
                return .none

            case .textButtonTapped:
                state.editMode = .textInputMode
                state.currentTextSize = .init(width: 0, height: 30)
                state.currentTextItem = .init()

                return .none

            case .uploadButtonTapped:
                state.isCapturing = true
                return .none

            case let .stickerListAction(.presented(.stickerSelected(selectedSticker))):
                state.stickerState.stickers.append(StickerItem(stickerName: selectedSticker))
                state.stickerModalState = nil
                return .send(.doneButtonTapped)

            case .stickerListAction(.dismiss):
                return .send(.doneButtonTapped)

            case .textInputCompleteButtonTapped:
                if var selectedText = state.selectedText,
                   let idx = state.textState.textItems.firstIndex(where: { $0.id == selectedText.id }) {

                    selectedText = state.currentTextItem ?? TextItem()
                    selectedText.text = state.inputText
                    selectedText.textSize = state.currentTextSize
                    state.textState.textItems[idx] = selectedText

                } else {
                    let newText: TextItem = .init(
                        text: state.inputText,
                        fontSize: state.currentTextItem?.fontSize ?? 24,
                        color: state.currentTextItem?.color ?? Color.white,
                        textSize: state.currentTextSize
                    )

                    state.textState.textItems.append(newText)
                }

                state.editMode = .original
                state.inputText = ""
                state.currentTextItem = nil
                state.currentTextSize = .zero
                state.selectedText = nil
                state.textState.selectedTextId = nil
                state.sliderState.sliderValue = CGFloat(24)

                return .none

            case let .updateTextScale(textId, scale):
                guard let index = state.texts.firstIndex(
                    where: { $0.id == textId }
                ) else { return .none }

                state.texts[index].fontSize = scale
                state.editMode = .original

                return .none

            case let .textColorTapped(newColor):
                state.currentTextItem?.color = newColor
                return .none

            case .doneButtonTapped:
                state.editMode = .original
                return .none

            case .objectLongerTapEnded:
                state.editMode = .original
                return .none

            case .sliderAction(.dragSlider):
                let sliderValue = state.sliderState.sliderValue
                state.currentTextItem?.fontSize = sliderValue

                return .none

            case .onAppear:
                state.isVideoPlaying = true

                if let _ = state.image {
                    state.dataType = .image
                } else {
                    state.dataType = .video
                }
                
                return .none

            case .onDisappear:
                state.isCapturing = false
                return .none

            case .captureImage:
                return .none

            case .renderVideo:
                guard let url = state.videoURL else { return .none }
                let (stickers, texts, isSoundOn) = (state.stickerState.stickers, state.texts, state.isVideoSoundOn)
                state.isVideoPlaying = false

                return .run { send in
                    do {
                        let outputURL = try await videoRenderService.renderVideo(
                            fromVideoAt: url,
                            stickers: stickers,
                            texts: texts,
                            isSoundOn: isSoundOn
                        )
                        await send(.pushToWriteBody(image: nil, videoURL: outputURL))
                    } catch {
                        print("Failed to render video: \(error.localizedDescription)")
                    }
                }

            case .pushToWriteBody:
                return .none

            case .stickerAction(.stickerDragged),
                    .stickerAction(.stickerLongTapped),
                    .stickerAction(.updateStickerScale),
                    .textAction(.textDragged),
                    .textAction(.textLongerTapped):
                state.editMode = .editMode
                return .none

            case .stickerAction(.stickerDragEnded),
                    .stickerAction(.stickerLongTapEnded),
                    .stickerAction(.scaleUpdateEnded),
                    .textAction(.textDragEnded),
                    .textAction(.textLongerTapEnded):
                state.editMode = .original
                return .none

            case let .setDeleteFrame(rect):
                state.stickerState.deleteRect = rect
                state.textState.deleteRect = rect
                return .none

            case let .textAction(.textTapped(textItem)):
                state.selectedText = textItem
                state.currentTextItem = textItem
                state.inputText = textItem.text
                state.editMode = .textInputMode
                state.currentTextSize = textItem.textSize
                state.sliderState.sliderValue = textItem.fontSize

                return .none

            case let .setTextSize(size):
                state.currentTextSize = size
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
