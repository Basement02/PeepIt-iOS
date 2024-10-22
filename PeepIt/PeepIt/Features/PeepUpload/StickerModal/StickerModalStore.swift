//
//  StickerModalStore.swift
//  PeepIt
//
//  Created by 김민 on 10/14/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct StickerModalStore {

    @ObservableState
    struct State: Equatable {
        let stickers = Sticker.allCases
    }

    enum Action {
        case stickerSelected(selectedSticker: Sticker)
    }
}

enum Sticker: String, Hashable, CaseIterable {
    case 😄
}

