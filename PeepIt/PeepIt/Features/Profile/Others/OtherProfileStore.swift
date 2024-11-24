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
//        var uploadedPeeps: [Peep] = [.stubPeep0, .stubPeep1, .stubPeep2, .stubPeep3]
        var uploadedPeeps: [Peep] = []
    }

    enum Action {

    }
}
