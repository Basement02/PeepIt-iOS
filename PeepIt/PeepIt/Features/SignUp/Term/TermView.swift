//
//  TermView.swift
//  PeepIt
//
//  Created by 김민 on 10/1/24.
//

import SwiftUI
import ComposableArchitecture

struct TermView: View {
    let store: StoreOf<TermStore>

    var body: some View {
        Text("약관 뷰")
    }
}

#Preview {
    TermView(
        store: .init(initialState: TermStore.State()) { TermStore() }
    )
}
