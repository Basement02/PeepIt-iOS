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
            case duplicated
            case valid

            var message: String {
                switch self {
                case .base, .valid:
                    return "SMS 전송으로 본인 인증을 진행합니다."
                case .formatError:
                    return "입력된 전화번호가 올바른지 다시 한 번 확인해주세요."
                case .duplicated:
                    return "이미 사용 중인 번호입니다."
                }
            }
        }

        var isPhoneNumberValid: Bool {
            return phoneNumberValid == .base || phoneNumberValid == .valid
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case skipButtonTapped
        case nextButtonTapped
        case backButtonTapped
        case debouncedText(newText: String)
        case moveToEnterCode(phone: String)

        /// 전화번호 중복체크 api
        case checkPhoneNumberDuplicated
        case fetchPhoneNumberCheckResponse(Result<Void, Error>)

        /// 인증번호 요청 api
        case requestSMSCode
        case fetchRequestSMSCodeResponse(Result<Void, Error>)
    }

    enum ID: Hashable {
        case debounce
    }

    @Dependency(\.authAPIClient) var authAPIClient
    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        BindingReducer()
            .onChange(of: \.phoneNumber) { oldValue, newValue in
                Reduce { state, action in
                    return .run { send in
                        await send(.debouncedText(newText: newValue))
                    }
                    .debounce(
                        id: ID.debounce,
                        for: 0.2,
                        scheduler: DispatchQueue.main
                    )
                }
            }

        Reduce { state, action in
            switch action {

            case .binding(\.phoneNumber):
                return .none

            case let .debouncedText(phoneNumber):
                guard !phoneNumber.isEmpty else {
                    state.phoneNumberValid = .base
                    return .none
                }

                guard phoneNumber.count == 11 &&
                        phoneNumber.hasPrefix("010") else {
                    state.phoneNumberValid = .formatError
                    return .none
                }

                return .send(.checkPhoneNumberDuplicated)

            case .nextButtonTapped:
                return .send(.requestSMSCode)

            case .backButtonTapped:
                return .run { _ in await self.dismiss() }

            case .checkPhoneNumberDuplicated:
                let phoneNumber = state.phoneNumber

                return .run { send in
                    await send(
                        .fetchPhoneNumberCheckResponse(
                            Result { try await authAPIClient.checkPhoneDuplicated(phoneNumber) }
                        )
                    )
                }

            case let .fetchPhoneNumberCheckResponse(result):
                switch result {

                case .success:
                    return .send(.requestSMSCode)

                case .failure:
                    // TODO: 중복처리
                    return .none
                }

            case .requestSMSCode:
                let phoneNumber = state.phoneNumber

                return .run { send in
                    await send(
                        .fetchRequestSMSCodeResponse(
                            Result { try await authAPIClient.sendSMSCode(phoneNumber) }
                        )
                    )
                }

            case let .fetchRequestSMSCodeResponse(result):
                switch result {
                case .success:
                    state.phoneNumberValid = .valid
                    return .send(.moveToEnterCode(phone: state.phoneNumber))

                case let .failure(error):
                    if error.asPeepItError() == .duplicatePhoneNumber {
                        state.phoneNumberValid = .duplicated
                    }

                    print(error)
                    return .none
                }

            case .moveToEnterCode, .skipButtonTapped:
                return .none

            default:
                return .none
            }
        }
    }
}
