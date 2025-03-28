//
//  InputIdStore.swift
//  PeepIt
//
//  Created by 김민 on 10/7/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct InputIdStore {

    @ObservableState
    struct State: Equatable {
        /// 현재 입력된 Id의 상태
        var idValidation = IdValidation.empty

        /// id 유효성 검증 종류 enum
        enum IdValidation {
            case empty
            case wrongWord
            case minCount
            case maxCount
            case duplicated
            case validated

            var message: String {
                switch self {
                case .empty:
                    return "영문, 숫자, 특수문자(_, ., -)만 사용 가능합니다."
                case .wrongWord:
                    return "사용할 수 없는 문자가 포함되어 있어요 :("
                case .minCount:
                    return "아이디로 사용하기에 너무 짧아요 :("
                case .maxCount:
                    return "아이디로 사용하기에 너무 길어요 :("
                case .duplicated:
                    return "이미 사용 중인 아이디입니다."
                case .validated:
                    return "사용 가능한 아이디입니다 :)"
                }
            }

            /// EnterState로 변환하여 하위 뷰 사용
            var enterState: EnterState {
                switch self {
                case .validated: return .completed
                case .empty: return .base
                default: return .error
                }
            }
        }

        /// 다음 버튼 활성화 여부
        var nextButtonEnabled: Bool {
            return idValidation == .validated
        }

        /// 입력창 히위 뷰 State
        var enterFieldState = CheckEnterFieldStore.State()
    }

    enum Action {
        /// 뷰 등장
        case onAppeared
        /// 다음 버튼 탭
        case nextButtonTapped
        /// 뒤로가기 버튼 탭
        case backButtonTapped
        /// 하위뷰 액션 연결
        case enterFieldAction(CheckEnterFieldStore.Action)
        /// 가이드라인 메세지 & 입력 상태 세팅
        case setEnterField

        /// id 중복 체크 api
        case checkIdDuplication(id: String)
        case fetchIdCheckResult(Result<Void, Error>)
    }

    @Dependency(\.authAPIClient) var authAPIClient
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {

        Scope(state: \.enterFieldState, action: \.enterFieldAction) {
            CheckEnterFieldStore()
        }

        Reduce { state, action in
            switch action {

            case .onAppeared:
                state.enterFieldState.fieldType = CheckEnterFieldStore.State.FieldType.id
                state.enterFieldState.message = state.idValidation.message
                return .none

            case .nextButtonTapped:
                return .none

            case .backButtonTapped:
                return .run { _ in await self.dismiss() }

            case let .enterFieldAction(.debouncedText(newText)):
                let regex = try! NSRegularExpression(pattern: "^[A-Za-z0-9._]+$")
                let range = NSRange(location: 0, length: newText.utf16.count)
                let isFormatValid = regex.firstMatch(in: newText, options: [], range: range) != nil

                if newText.count == 0 {
                    state.idValidation = .empty
                } else if !isFormatValid {
                    state.idValidation = .wrongWord
                } else if newText.count < 10 {
                    state.idValidation = .minCount
                } else if newText.count >= 10 && newText.count <= 20 {
                    return .send(.checkIdDuplication(id: newText))
                } else if newText.count > 20 {
                    state.idValidation = .maxCount
                }

                return .send(.setEnterField)

            case let .checkIdDuplication(newText):
                return .run { send in
                    await send(
                        .fetchIdCheckResult(
                            Result { try await authAPIClient.checkIdDuplicate(newText) }
                        )
                    )
                }

            case let .fetchIdCheckResult(result):
                switch result {
                
                case .success:
                    state.idValidation = .validated

                case let .failure(error):
                    guard
                        let networkError = error as? NetworkError,
                        case let .serverError(exception) = networkError,
                        let errorCase = PeepItError(rawValue: exception.code)
                    else { return .none }

                    if errorCase == .duplicateId { state.idValidation = .duplicated }
                }

                return .send(.setEnterField)

            case .setEnterField:
                state.enterFieldState.enterState = state.idValidation.enterState
                state.enterFieldState.message = state.idValidation.message
                return .none

            default:
                return .none
            }
        }
    }
}
