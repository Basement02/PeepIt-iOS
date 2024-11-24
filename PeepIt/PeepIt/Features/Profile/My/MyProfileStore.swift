//
//  MyProfileStore.swift
//  PeepIt
//
//  Created by 김민 on 9/23/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MyProfileStore {

    @ObservableState
    struct State: Equatable {
        var peepTabSelection = PeepTabType.uploaded
        var uploadedPeeps = [Peep.stubPeep0]
        var activityPeeps = [Peep.stubPeep0]
        var reactedPeeps = [ReactedPeep]()
        var commentedPeeps = [CommentedPeep]()
    }

    enum Action {
        case onAppear
        case peepTabTapped(selection: PeepTabType)
        case loadUploadedPeeps
        case loadReactedPeeps
        case loadCommentPeeps
        case backButtonTapped
        case uploadButtonTapped
        case modifyButtonTapped
    }

    var body: some Reducer<State, Action>  {
        Reduce { state, action in
            switch action {

            case .onAppear:
                return .merge(
                    .send(.loadUploadedPeeps)
                )

            case let .peepTabTapped(selection):
                state.peepTabSelection = selection

                if selection == .myActivity {
                    return .merge(
                        .send(.loadReactedPeeps),
                        .send(.loadCommentPeeps)
                    )
                }

                return .none

            case .loadUploadedPeeps:
                return .none

            case .loadReactedPeeps:
                state.reactedPeeps = [.reactPeepStub]
                return .none

            case .loadCommentPeeps:
                state.commentedPeeps = [.commentPeepStub]
                return .none

            case .backButtonTapped:
                return .none

            case .uploadButtonTapped:
                return .none

            case .modifyButtonTapped:
                return .none
            }
        }
    }
}
