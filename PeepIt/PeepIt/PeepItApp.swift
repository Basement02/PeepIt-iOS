//
//  PeepItApp.swift
//  PeepIt
//
//  Created by 김민 on 9/12/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct PeepItApp: App {

    init() {
        KakaoSDK.initSDK(appKey: Environment.kakaoAppKey)
    }

    var body: some Scene {
        WindowGroup {
            RootView(
                store: .init(initialState: RootStore.State()) { RootStore() }
            )
        }
    }
}
