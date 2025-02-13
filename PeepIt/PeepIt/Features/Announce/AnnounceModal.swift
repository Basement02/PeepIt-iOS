//
//  AnnounceModal.swift
//  PeepIt
//
//  Created by 김민 on 11/22/24.
//

import SwiftUI
import ComposableArchitecture

struct AnnounceModal: View {
    let store: StoreOf<AnnounceStore>

    var body: some View {
        VStack(spacing: 0) {
            PeepItNavigationBar(
                title: "서비스 소식",
                trailing: dismissButton
            )

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    title
                        .padding(.top, 39)
                        .padding(.bottom, 30)

                    content

                    if let _ = store.selectedAnnounce?.image { image }
                }
            }
            .padding(.horizontal, 29)

            Spacer()
        }
        .background(Color.base)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var dismissButton: some View {
        DismissButton {
            store.send(.closeSheet)
        }
    }

    private var title: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(store.selectedAnnounce?.category ?? "")
                .pretendard(.caption01)
                .foregroundStyle(Color.coreLime)

            Text(store.selectedAnnounce?.title ?? "")
                .pretendard(.title02)

            Text(store.selectedAnnounce?.date ?? "")
                .pretendard(.caption02)
                .foregroundStyle(Color.nonOp)

            Rectangle()
                .fill(Color.op)
                .frame(height: 0.5)
        }
    }

    private var content: some View {
        HStack {
            Text(
                store.selectedAnnounce?.content.forceCharWrapping ?? ""
            )
            .pretendard(.body05)
            .multilineTextAlignment(.leading)
            .padding(.bottom, 30.adjustedH)

            Spacer()
        }
    }

    // TODO:
    private var image: some View {
        Rectangle()
            .fill(Color.gray900)
            .frame(width: 335, height: 150)
    }
}

#Preview {
    AnnounceModal(
        store: .init(initialState: AnnounceStore.State()) { AnnounceStore() }
    )
}
