//
//  AuthenticationStore.swift
//  PeepIt
//
//  Created by 김민 on 10/1/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AuthenticationStore {

    @ObservableState
    struct State: Equatable {
        /// 휴대폰 번호 바인딩
        var phoneNumber = ""

        /// 휴대폰 번호 유효성 판단
        var phoneNumberValid = PhoneNumberValidation.base

        enum PhoneNumberValidation {
            case base
            case formatError
            case valid

            var message: String {
                switch self {
                case .base, .valid:
                    return "SMS 전송으로 본인 인증을 진행합니다."
                case .formatError:
                    return "입력된 전화번호가 올바른지 다시 한 번 확인해주세요."
                }
            }
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case skipButtonTapped
        case nextButtonTapped
        case backButtonTapped
    }

    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.phoneNumber):
                state.phoneNumberValid = isValidPhoneNumber(of: state.phoneNumber)
                return .none
                
            case .skipButtonTapped:
                return .none

            case .nextButtonTapped:
                // TODO: 중복된 번호인지 검사
                return .none

            case .backButtonTapped:
                return .run { _ in
                    await self.dismiss()
                }

            default:
                return .none
            }
        }
    }

    /// 유효성 판단 함수
    func isValidPhoneNumber(of phoneNumber: String)
    -> AuthenticationStore.State.PhoneNumberValidation {
        guard !phoneNumber.isEmpty else {
            return .base
        }

        guard phoneNumber.count == 11 else {
            return .formatError
        }

        guard phoneNumber.hasPrefix("010") else {
            return .formatError
        }

        return .valid
    }
}
