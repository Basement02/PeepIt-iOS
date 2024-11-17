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
        /// focus되는 field - 초기: 첫 번째 tf로 설정
        var focusField: Field? = .first

        /// 인증 코드를 저장할 배열
        var fields = Array(repeating: "", count: 6)

        /// 인증이 성공했는지를 판단
        var isAuthSucceed = false

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
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case checkAuthCode(code: String)
    }
    
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
                if state.fields.allSatisfy({ $0.count == 1 }) {
                    let code = state.fields.joined(separator: "")
                    return .send(.checkAuthCode(code: code))
                }

                return .none

            case .checkAuthCode:
                // TODO: 인증 API
                state.isAuthSucceed = true
                return .none

            default:
                return .none
            }
        }
    }
}
