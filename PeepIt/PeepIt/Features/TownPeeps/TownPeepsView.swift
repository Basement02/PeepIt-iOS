//
//  TownPeepsView.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import SwiftUI
import ComposableArchitecture

struct TownPeepsView: View {
    let store: StoreOf<TownPeepsStore>

    var body: some View {
        Text("동네 소식")
    }
}

#Preview {
    TownPeepsView(
        store: .init(initialState: TownPeepsStore.State()) { TownPeepsStore() }
    )
}
