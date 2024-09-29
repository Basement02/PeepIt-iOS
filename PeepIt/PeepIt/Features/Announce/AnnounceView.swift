//
//  AnnounceView.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import SwiftUI
import ComposableArchitecture

struct AnnounceView: View {
    let store: StoreOf<AnnounceStore>

    var body: some View {
        Text("서비스 소식")
    }
}

#Preview {
    AnnounceView(
        store: .init(initialState: AnnounceStore.State()) { AnnounceStore() }
    )
}
