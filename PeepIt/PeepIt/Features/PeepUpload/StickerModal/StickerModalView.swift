//
//  StickerModalView.swift
//  PeepIt
//
//  Created by 김민 on 10/14/24.
//

import SwiftUI
import ComposableArchitecture

struct StickerModalView: View {
    let store: StoreOf<StickerModalStore>

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    StickerModalView(
        store: .init(initialState: StickerModalStore.State()) { StickerModalStore() }
    )
}
