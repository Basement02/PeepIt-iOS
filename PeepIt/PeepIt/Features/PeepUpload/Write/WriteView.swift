//
//  WriteView.swift
//  PeepIt
//
//  Created by 김민 on 10/13/24.
//

import SwiftUI
import ComposableArchitecture

struct WriteView: View {
    let store: StoreOf<WriteStore>

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    WriteView(
        store: .init(initialState: WriteStore.State()) { WriteStore() }
    )
}
