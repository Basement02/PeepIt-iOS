//
//  AnnounceView.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import SwiftUI
import ComposableArchitecture

struct AnnounceView: View {
    @Perception.Bindable var store: StoreOf<AnnounceStore>

    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                PeepItNavigationBar(
                    leading: backButton,
                    title: "서비스 소식"
                )

                announceList
                    .padding(.top, 23)
            }
            .background(Color.base)
            .toolbar(.hidden, for: .navigationBar)
            .fullScreenCover(isPresented: $store.isSheetVisible) {
                AnnounceModal(store: self.store)
            }
        }
    }

    private var backButton: some View {
        BackButton {
            store.send(.backButtonTapped)
        }
    }

    private var announceList: some View {
        List(store.announces) { item in
            AnnounceCell(announce: item)
                .listRowInsets(EdgeInsets())
                .background(Color.base)
                .onTapGesture {
                    store.send(.announceTapped(announce: item))
                }
        }
        .listRowSpacing(15)
        .listRowSeparator(.hidden)
        .listStyle(.plain)
    }
}

fileprivate struct AnnounceCell: View {
    let announce: Announce

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(announce.isRead ? Color.gray800 : Color.gray600)

            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(announce.category)
                        .pretendard(.caption01)
                        .foregroundStyle(Color.coreLime)

                    Text(announce.title)
                        .pretendard(.subhead)

                    Text(announce.content)
                        .pretendard(.body04)
                        .lineLimit(5)
                        .truncationMode(.tail)
                        .multilineTextAlignment(.leading)

                    Text(announce.date)
                        .pretendard(.caption02)
                        .foregroundStyle(Color.nonOp)
                }

                Spacer()
            }
            .padding(.vertical, 22)
            .padding(.horizontal, 21.5)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    AnnounceView(
        store: .init(initialState: AnnounceStore.State()) { AnnounceStore() }
    )
}
