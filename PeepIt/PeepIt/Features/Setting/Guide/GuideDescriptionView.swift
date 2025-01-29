//
//  GuideDescriptionView.swift
//  PeepIt
//
//  Created by 김민 on 1/29/25.
//

import SwiftUI
import ComposableArchitecture

struct GuideDescriptionView: View {
    let store: StoreOf<GuideStore>

    var body: some View {
        VStack(spacing: 0) {
            PeepItNavigationBar(
                title: store.selectedGuideType?.rawValue ?? "",
                trailing: DismissButton { store.send(.sheetDismissButtonTapped)
                }
            )

            Spacer()
        }
        .background(Color.base)
    }
}

#Preview {
    GuideDescriptionView(
        store: .init(initialState: GuideStore.State()) {
            GuideStore()
        }
    )
}
