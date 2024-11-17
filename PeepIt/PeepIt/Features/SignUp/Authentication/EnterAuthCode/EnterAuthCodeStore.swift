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
        var focusField: Field?

        var first = ""
        var second = ""
        var third = ""
        var fourth = ""
        var fifth = ""
        var sixth = ""

        var fields: [String] {
            get {
                [first, second, third, fourth, fifth, sixth]
            }
            set {
                guard newValue.count == 6 else { return }
                
                first = newValue[0]
                second = newValue[1]
                third = newValue[2]
                fourth = newValue[3]
                fifth = newValue[4]
                sixth = newValue[5]
            }
        }

        enum Field: CaseIterable {
            case first, second, third, fourth, fifth, sixth
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
    }

    var body: some Reducer<State, Action> {
      BindingReducer()

      Reduce { state, action in
        switch action {
        case .binding:
          return .none
        }
      }
    }
}
