//
//  CameraView.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import SwiftUI
import ComposableArchitecture

struct CameraView: View {
    let store: StoreOf<CameraStore>

    var body: some View {
        Text("핍 업로드")
    }
}

#Preview {
    CameraView(
        store: .init(initialState: CameraStore.State()) { CameraStore() }
    )
}
