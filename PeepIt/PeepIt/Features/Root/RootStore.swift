//
//  RootStore.swift
//  PeepIt
//
//  Created by 김민 on 9/28/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct RootStore {

    @Reducer(state: .equatable)
    enum Path {
        case home(HomeStore)
        case myProfile(MyProfileStore)
    }

    @ObservableState
    struct State {
        var path = StackState<Path.State>([RootStore.rootPath])

        var home = HomeStore.State()

        enum LoginState: Equatable {
            case notRegistered
            case registered
            case authorized
        }
    }

    enum Action {
        case path(StackActionOf<Path>)
        case home(HomeStore.Action)
    }

    var body: some Reducer<State, Action> {

        Reduce { state, action in
            switch action {

            case let .path(action):

                switch action {
                /// 프로필로 이동
                case .element(id: _, action: .home(.profileButtonTapped)):
                    state.path.append(.myProfile(.init()))
                    return .none

                /// 프로필 뒤로가기 버튼
                case let .element(id, action: .myProfile(.backButtonTapped)):
                    state.path.pop(from: id)
                    return .none

                default:
                    return .none
                }

            case .home:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

extension RootStore {

    private static var rootPath: Path.State {
        return .home(.init())
    }
}
