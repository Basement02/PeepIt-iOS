//
//  BlockListView.swift
//  PeepIt
//
//  Created by 김민 on 11/26/24.
//

import SwiftUI
import ComposableArchitecture

struct BlockListView: View {
    let store: StoreOf<BlockListStore>

    var body: some View {
        VStack(spacing: 0) {
            PeepItNavigationBar(
                title: "차단한 계정",
                trailing: dismissButton
            )
            .padding(.bottom, 39.adjustedH)

            Group {
                header
                    .padding(.bottom, 24 )

                blockList

            }
            .padding(.horizontal, 29)

            Spacer()
        }
        .background(Color.base)
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea(.all, edges: .bottom)
    }

    private var dismissButton: some View {
        DismissButton {
            store.send(.dismissButtonTapped)
        }
    }

    private var header: some View {
        HStack {
            Text("\(store.blockList.count)명")
                .pretendard(.body04)
                .foregroundStyle(Color.gray400)
            Spacer()
        }
    }

    private var blockList: some View {
        List(store.blockList, id: \.id) { blockedUser in
            HStack(spacing: 13) {
                Image("ProfileSample")
                    .resizable()
                    .frame(width: 31.4, height: 31.4)

                Text("@\(blockedUser.id)")
                    .pretendard(.body04)

                Spacer()

                Button {
                    // TODO: - 차단 해제 action 연결
                } label: {
                    Text("차단해제")
                        .pretendard(.caption02)
                        .underline()
                        .foregroundStyle(Color.white)
                }
                .frame(width: 44, height: 44)
            }
            .listRowInsets(.init())
            .listRowSeparator(.hidden)
            .listRowBackground(Color.base)
        }
        .listStyle(.plain)
        .listRowSpacing(14)
    }
}

#Preview {
    BlockListView(
        store: .init(initialState: BlockListStore.State()) {
            BlockListStore()
        }
    )
}
