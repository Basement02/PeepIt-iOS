//
//  ProfileInfoStore.swift
//  PeepIt
//
//  Created by 김민 on 10/7/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ProfileInfoStore {

    @ObservableState
    struct State: Equatable {
        var nickname = ""
        var date = ""
        var selectedGender: GenderType?

        var guideline: String {
            return isBirthValidate ? "" : "생년월일이 유효하지 않아 넘어갈 수 없어요 :("
        }
        var isBirthValidate: Bool {
            return isYearValid && isMonthValid && isDayValid
        }

        var isYearValid = true
        var isMonthValid = true
        var isDayValid = true
        var isLengthValid = false
        var endEdit = false

        @Shared(.inMemory("userInfo")) var userInfo: UserProfile = .init()
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        /// 성별 선택
        case selectedGender(GenderType)
        /// 다음 버튼 탭
        case nextButtonTapped
        /// 뒤로가기 버튼 탭
        case backButtonTapped
        /// date text field debouncing
        case dateDebounced(String)
        /// 텍스트 필드 포커스됐을 때
        case tfFocusing
        /// 텍스트 필드 포커스 해제됐을 때
        case tfNotFocusing
    }

    enum ID: Hashable {
        case debounce
    }

    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {

            case .binding(\.date):
                let date = state.date

                return .run { send in
                    await send(.dateDebounced(date))
                }
                .debounce(id: ID.debounce, for: 0.003, scheduler: DispatchQueue.main)

            case let .selectedGender(gender):
                state.selectedGender = state.selectedGender == gender ? nil : gender
                return .none

            case .nextButtonTapped:
                state.userInfo.birth = state.date.replacingOccurrences(of: ".", with: "-")
                state.userInfo.gender = state.selectedGender ?? .notSelected
                return .none

            case .backButtonTapped:
                return .run { _ in await self.dismiss() }

            case let .dateDebounced(date):
                var year = 0
                var month = 0
                var day = 0

                switch date.count {
                case 4: // 연도
                    year = Int(date.prefix(4))!

                    // 현재 연도 가져오기
                    let currentYear = Calendar.current.component(.year, from: Date())

                    // 연도 범위 검증 (1900년부터 올해까지)
                    guard (1900...currentYear).contains(year) else {
                        state.isYearValid = false
                        return .none
                    }

                    state.isYearValid = true

                case 6: // 연도 + 월
                    month = Int(date.suffix(2))!

                    guard (1...12).contains(month) else {
                        state.isMonthValid = false
                        return .none
                    }

                    state.isMonthValid = true

                case 8: // 연도 + 월 + 일
                    day = Int(date.suffix(2))!

                    var dateComponents = DateComponents()
                    dateComponents.year = year
                    dateComponents.month = month

                    let calendar = Calendar.current
                    guard let range = calendar.range(
                        of: .day,
                        in: .month,
                        for: calendar.date(from: dateComponents)!
                    ) else {
                        return .none
                    }

                    guard range.contains(day) else {
                        state.isDayValid = false
                        return .none
                    }

                    state.isDayValid = true
                    state.endEdit = true

                default: // 8자 초과 방지
                    let originDate = state.date.replacingOccurrences(of: ".", with: "")

                    guard originDate.count < 8 else {
                        state.date = String(state.date.prefix(8))
                        return .none
                    }
                }

                return .none

            case .tfFocusing: 
                guard state.isBirthValidate && state.date.count == 8 else {
                    return .none
                }

                let year = state.date.prefix(4)         
                let month = state.date.dropFirst(4).prefix(2)
                let day = state.date.suffix(2)

                state.date = "\(year).\(month).\(day)"

                return .none

            case .tfNotFocusing:
                state.date = state.date.replacingOccurrences(of: ".", with: "")
                return .none

            default:
                return .none
            }
        }
    }
}
