//
//  InputProfileView.swift
//  PeepIt
//
//  Created by 김민 on 10/1/24.
//

import SwiftUI
import ComposableArchitecture

struct InputProfileView: View {
    let store: StoreOf<InputProfileStore>

    var body: some View {
        Text("정보 입력")
    }
}

#Preview {
    InputProfileView(
        store: .init(initialState: InputProfileStore.State()) { InputProfileStore() }
    )
}
