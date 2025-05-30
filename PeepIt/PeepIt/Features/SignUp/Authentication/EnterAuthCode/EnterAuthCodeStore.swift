//
//  EnterAuthCodeStore.swift
//  PeepIt
//
//  Created by 김민 on 11/15/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct EnterAuthCodeStore {

    @ObservableState
    struct State: Equatable {
        /// 이전 뷰에서 넘어온 전화번호
        var phoneNumber = ""
        /// focus되는 field - 초기: 첫 번째 tf로 설정
        var focusField: Field? = .first
        /// 인증 코드를 저장할 배열
        var fields = Array(repeating: "", count: 6)
        /// 인증이 성공했는지를 판단
        var authCodeState = AuthCodeState.none
        /// focus될 Field 정의
        enum Field: CaseIterable, Hashable {
            case first, second, third, fourth, fifth, sixth

            var next: Field? {
                let allCases = Self.allCases
                guard let currentIndex = allCases.firstIndex(of: self),
                      currentIndex + 1 < allCases.count else {
                    return nil
                }
                return allCases[currentIndex + 1]
            }
        }

        enum AuthCodeState: Equatable {
            case none /// 인증 전
            case check /// 인증 중
            case success /// 인증 성공
            case fail /// 인증 실패
        }

        /// 인증 시간(5분으로 시작)
        var time = 300
        var isTimerRunning = false
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)

        /// 뷰 나타날 때
        case onAppear
        /// 뒤로가기 버튼 탭
        case backButtonTapped
        /// 완료뷰로 이동
        case pushToWelcomeView
        /// 스킵 버튼
        case skipButtonTapped

        /// 타이머
        case startTimer
        case timerTicked

        /// 인증 번호 확인 api
        case checkSMSCodeVerified
        case fetchCodeVerifiedResult(Result<Void, Error>)
    }

    enum CancelId {
        case timer
    }

    @Dependency(\.authAPIClient) var authAPIClient
    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {

            case .binding(\.fields):
                /// 코드 tf가 채워지면, 다음 tf로 focus 이동
                
                for (index, field) in state.fields.enumerated() {
                    if field.count == 1,
                        let currentFocus = state.focusField,
                        State.Field.allCases[index] == currentFocus {
                        state.focusField = currentFocus.next
                        break
                    } 
                }

                /// 6개 전부 채워졌을 때는 인증 api 호출 (TODO)
                if state.fields.allSatisfy({ $0.count == 1 })
                    && (state.authCodeState == .none || state.authCodeState == .fail)  {
                    state.authCodeState = .check
                    return .send(.checkSMSCodeVerified)
                }

                return .none

            case .onAppear:
                return .send(.startTimer)

            case .backButtonTapped:
                return .run { _ in await self.dismiss() }

            case .pushToWelcomeView, .skipButtonTapped:
                return .none

            case .startTimer:
                state.isTimerRunning = true
                state.time = 300

                return .run { send in
                    while true {
                        try await Task.sleep(for: .seconds(1))
                        await send(.timerTicked)
                    }
                }
                .cancellable(id: CancelId.timer)

            case .timerTicked:
                guard state.time > 0 else {
                    state.isTimerRunning = false
                    return .cancel(id: CancelId.timer)
                }

                state.time -= 1
                return .none

            case .checkSMSCodeVerified:
                let phoneNumber = state.phoneNumber
                let code = state.fields.joined()

                return .run { send in
                    await send(
                        .fetchCodeVerifiedResult(
                            Result { try await authAPIClient.checkSMSCodeVerified(phoneNumber, code) }
                        )
                    )
                }

            case let .fetchCodeVerifiedResult(result):
                switch result {

                case .success:
                    state.authCodeState = .success
                    state.isTimerRunning = false

                    return .run { send in
                        try await Task.sleep(for: .seconds(0.5))
                        await send(.pushToWelcomeView)
                    }

                case let .failure(error):
                    if error.asPeepItError() == .smsCodeFailed
                        || error.asPeepItError() == .smsCodeInvalidate {
                        state.authCodeState = .fail
                    }

                    return .none

                }

            default:
                return .none
            }
        }
    }
}
