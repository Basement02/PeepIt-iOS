//
//  UploadView.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import SwiftUI
import ComposableArchitecture

struct UploadView: View {
    let store: StoreOf<UploadStore>

    var body: some View {
        Text("핍 업로드")
    }
}

#Preview {
    UploadView(
        store: .init(initialState: UploadStore.State()) { UploadStore() }
    )
}
