//
//  NotificationView.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import SwiftUI
import ComposableArchitecture

struct NotificationView: View {
    let store: StoreOf<NotificationStore>

    var body: some View {
        Text("알림")
    }
}

#Preview {
    NotificationView(
        store: .init(initialState: NotificationStore.State()) { NotificationStore() }
    )
}
