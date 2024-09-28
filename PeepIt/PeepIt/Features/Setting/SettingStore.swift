//
//  SettingStore.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SettingStore {

    @ObservableState
    struct State: Equatable {

    }

    enum Action {

    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                
            }
        }
    }
}
