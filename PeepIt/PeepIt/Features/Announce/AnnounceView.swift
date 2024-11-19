//
//  AnnounceView.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import SwiftUI
import ComposableArchitecture

struct AnnounceView: View {
    let store: StoreOf<AnnounceStore>

    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                NavigationBar(
                    leadingButton: backButton,
                    title: "서비스 소식"
                )

                announceList
                    .padding(.top, 23.adjustedH)
            }
            .background(Color.base)
        }
    }

    private var backButton: some View {
        Button {
            // TODO:
        } label: {
            Image("backN")
                .opacity(0)
        }
        .buttonStyle(
            PressableButtonStyle(
                originImg: "backN",
                pressedImg: "backY"
            )
        )
    }

    private var announceList: some View {
        List(store.announces) { item in
            AnnounceCell(announce: item)
                .listRowInsets(EdgeInsets())
                .background(Color.base)
        }
        .listRowSpacing(15)
        .listRowSeparator(.hidden)
        .listStyle(.plain)
    }
}

fileprivate struct AnnounceCell: View {
    let announce: Announce

    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .leading, spacing: 10) {
                Text(announce.category)
                    .pretendard(.caption01)
                    .foregroundStyle(Color.coreLime)

                Text(announce.title)
                    .pretendard(.subhead)

                Text(announce.content)
                    .pretendard(.body04)
                    .lineLimit(2)
                    .truncationMode(.tail)

                Text(announce.date)
                    .pretendard(.caption02)
                    .foregroundStyle(Color.nonOp)
            }
            .frame(width: 318)
            .padding(.vertical, 22)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray500)
        )
        .padding(.horizontal, 16)
    }
}

#Preview {
    AnnounceView(
        store: .init(initialState: AnnounceStore.State()) { AnnounceStore() }
    )
}
