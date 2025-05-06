//
//  ReactionListView.swift
//  PeepIt
//
//  Created by 김민 on 5/7/25.
//

import SwiftUI
import ComposableArchitecture

struct ReactionListView: View {
    let store: StoreOf<ReactionListStore>

    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 15) {
                if store.showReactionList {
                    reactionListView
                } else {
                    initialReactionView(reaction: nil)
                }
            }
            .onAppear { store.send(.onAppear) }
        }
    }

    private func initialReactionView(
        reaction: ReactionListStore.State.ReactionType?
    ) -> some View {
        Group {
            if let selectedReaction = store.selectedReaction {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.coreLimeOp)
                    .frame(width: 50, height: 50)
                    .overlay {
                        Text(selectedReaction.rawValue)
                            .font(.system(size: 24))
                    }
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blur2)
                    .frame(width: 50, height: 50)
                    .overlay {
                        Text(store.reactionList[store.showingReactionIdx].rawValue)
                            .font(.system(size: 24))
                        Text("")
                            .font(.system(size: 24))
                    }
            }
        }
        .onTapGesture { store.send(.initReactionButtonTapped) }
    }

    private var reactionListView: some View {
        ZStack {
            BackdropBlurView(bgColor: .blur2, radius: 5)
                .frame(width: 50, height: 250)

            VStack(spacing: 0) {
                ForEach(
                    Array(zip(store.reactionList.indices,
                              store.reactionList))
                    , id: \.0
                ) { idx, reaction in
                    ZStack(alignment: .bottom) {
                        reactionCell(reaction: reaction)

                        if idx < store.reactionList.count - 1 {
                            Rectangle()
                                .fill(Color.op)
                                .frame(width: 34, height: 0.5)
                        }
                    }
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    @ViewBuilder
    private func reactionCell(
        reaction: ReactionListStore.State.ReactionType
    ) -> some View {
        if let selectedReaction = store.selectedReaction,
           selectedReaction.rawValue == reaction.rawValue  {
            Button {
                store.send(.unselectReaction)
            } label: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.coreLimeOp)
                    .frame(width: 50, height: 50)
                    .overlay {
                        Text(reaction.rawValue)
                            .font(.system(size: 24))
                    }
            }
        } else {
            Button {
                store.send(.selectReaction(selectedReaction: reaction))
            } label: {
                Rectangle()
                    .frame(width: 50, height: 50)
                    .hidden()
            }
            .buttonStyle(
                PressableViewButtonStyle(
                    normalView: RoundedRectangle(cornerRadius: 12)
                        .fill(Color.clear).contentShape(Rectangle()),
                    pressedView: RoundedRectangle(cornerRadius: 12).fill(Color.blur1)
                )
            )
            .frame(width: 50, height: 50)
            .overlay {
                Text(reaction.rawValue).font(.system(size: 24))
            }
        }
    }
}

#Preview {
    ReactionListView(
        store: .init(initialState: ReactionListStore.State()) {
            ReactionListStore()
        }
    )
}
