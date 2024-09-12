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
            ContentView(
                store: .init(initialState: HomeStore.State()) { HomeStore() }
            )
        }
    }
}
