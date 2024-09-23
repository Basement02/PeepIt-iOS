//
//  OtherProfileStore.swift
//  PeepIt
//
//  Created by 김민 on 9/24/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct OtherProfileStore {

    @ObservableState
    struct State: Equatable {
        var uploadedPeeps = [Peep]()
    }

    enum Action {

    }

    var body: some Reducer<State, Action>  {
        Reduce { state, action in
            switch action {
            }
        }
    }
}
