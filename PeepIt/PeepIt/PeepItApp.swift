//
//  PeepItApp.swift
//  PeepIt
//
//  Created by 김민 on 9/12/24.
//

import SwiftUI

@main
struct PeepItApp: App {
    var body: some Scene {
        WindowGroup {
//            RootView(
//                store: .init(initialState: RootStore.State()) { RootStore() }
//            )

            OtherProfileView(
                store: .init(initialState: OtherProfileStore.State()) {
                    OtherProfileStore()
                }
            )
        }
    }
}
