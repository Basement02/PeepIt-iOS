//
//  BlockListStore.swift
//  PeepIt
//
//  Created by 김민 on 11/26/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct BlockListStore {

    @ObservableState
    struct State: Equatable {
        /// 차단 목록
        var blockList: [UserProfile] = [.stubUser1, .stubUser2]
    }

    enum Action {
        /// 우측 닫기 버튼 탭
        case dismissButtonTapped
        /// 차단 해제 버튼 탭
        case unblockButtonTapped
    }

    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {

            case .dismissButtonTapped:
                return .run { _ in
                    await dismiss()
                }

            case .unblockButtonTapped:
                // TODO: 프로필 구분 파라미터 추가, 차단 해제 API 호출
                return .none
            }
        }
    }
}
