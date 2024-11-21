//
//  PeepDetailView.swift
//  PeepIt
//
//  Created by 김민 on 9/16/24.
//

import SwiftUI
import ComposableArchitecture

struct PeepDetailView: View {
    let store: StoreOf<PeepDetailStore>

    var body: some View {
        WithPerceptionTracking {
            ZStack(alignment: .topTrailing) {
                Color.white
                    .ignoresSafeArea()

                BackImageLayer.secondary()
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    topBar

                    Spacer()

                    detailView
                        .padding(.bottom, 84.adjustedH)
                }
                .padding(.horizontal, 16.adjustedW)

                if store.state.showElseMenu {
                    menuView
                        .padding(.top, 59)
                        .padding(.trailing, 36.adjustedW)
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}

extension PeepDetailView {

    private var topBar: some View {
        HStack {
            backButton
            Spacer()

            locationButton

            Spacer()
            moreButton
        }
        .frame(height: 44)
    }

    private var backButton: some View {
        BackButton {
            store.send(.closeView)
        }
    }

    private var moreButton: some View {
        Button {
            store.send(.setShowingElseMenu(!store.showElseMenu))
        } label: {
            Rectangle()
                .fill(Color.clear)
                .frame(width: 33.6, height: 33.6)
        }
        .buttonStyle(
            PressableButtonStyle(originImg: "ElseN", pressedImg: "ElseY")
        )
    }

    private var locationButton: some View {
        HStack(spacing: 2) {
            Image("IconLocation")
                .frame(width: 22.4, height: 22.4)

            Text("동이름, 건물 이름")
                .pretendard(.body02)
        }
        .padding(.leading, 15)
        .padding(.trailing, 23)
        .padding(.vertical, 9)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blur2)
        )
    }

    private var menuView: some View {
        VStack(spacing: 9) {
            shareButton

            Rectangle()
                .frame(width: 108, height: 0.45)
                .foregroundStyle(Color.op)

            reportButton
        }
        .padding(.vertical, 17)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blur2)
                .frame(width: 146)
        )
    }

    private var shareButton: some View {
        Button {
            // TODO: 공유하기
        } label: {
            HStack(spacing: 3) {
                Image("CombiShareBtnN")
                    .opacity(0)
                Text("공유하기")
            }
            .opacity(0)
        }
        .buttonStyle(
            PressableViewButtonStyle(
                normalView:
                    HStack(spacing: 3) {
                        Image("CombiShareBtnN")
                        Text("공유하기")
                    },
                pressedView:
                    HStack(spacing: 3) {
                        Image("CombiShareBtnY")
                        Text("공유하기")
                            .pretendard(.body04)
                    }
                    .foregroundStyle(Color.gray300)
            )
        )
    }

    private var reportButton: some View {
        Button {
            // TODO: 신고하기
        } label: {
            HStack(spacing: 3) {
                Image("CombiReportBtnN")
                Text("신고하기")
            }
            .opacity(0)
        }
        .buttonStyle(
            PressableViewButtonStyle(
                normalView:
                    HStack(spacing: 3) {
                        Image("CombiReportBtnN")
                        Text("신고하기")
                    }
                    .foregroundStyle(Color.coreRed),
                pressedView:
                    HStack(spacing: 3) {
                        Image("CombiReportBtnY")
                        Text("신고하기")
                            .pretendard(.body04)
                    }
                    .foregroundStyle(Color.gray300)
            )
        )
    }

    private var detailView: some View {
        HStack(alignment: .bottom, spacing: 12) {
            VStack(spacing: 9) {
                nameView

                Text("한 문장은 몇 자까지일까? 어쨋든 말줄임표를 두 문장까지? 문장 끝까지 보이면 안될 것 같지 않아?")
                    .pretendard(.body03)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .truncationMode(.tail)
            }

            VStack(spacing: 15) {
                if store.state.showReactionList {
                    reactionListView
                } else {
                    reactionButton
                }

                chattingButton
            }
        }
    }

    private var nameView: some View {
        HStack {
            Image("ProfileSample")
                .resizable()
                .frame(width: 37.62, height: 37.62)
            Text("hyerim")
                .pretendard(.headline)
            Text("3분 전")
                .pretendard(.caption04)

            Spacer()
        }
    }

    private var chattingButton: some View {
        Button {
            // TODO: 채팅뷰 올리기
        } label: {
            Image("IconMessage")
                .resizable()
                .frame(width: 29.66, height: 29.66)
        }
        .buttonStyle(
            PressableViewButtonStyle(
                normalView:
                    RoundedRectangle(cornerRadius: 13.95)
                        .fill(Color.blur2)
                        .frame(width: 50, height: 50),
                pressedView:
                    RoundedRectangle(cornerRadius: 13.95)
                        .fill(Color.blur1)
                        .frame(width: 50, height: 50)
            )
        )
    }

    private var reactionButton: some View {
        Button {
            store.send(
                .setShowingReactionState(!store.state.showReactionList)
            )
        } label: {
            RoundedRectangle(cornerRadius: 11.82)
                .fill(Color.clear)
                .frame(width: 50, height: 50)
        }
        .buttonStyle(
            PressableViewButtonStyle(
                normalView:
                    RoundedRectangle(cornerRadius: 11.82)
                        .fill(
                            store.selectedReaction == nil ?
                            Color.blur2: Color.coreLime.opacity(0.5)
                        )
                        .frame(width: 50, height: 50),
                pressedView:
                    RoundedRectangle(cornerRadius: 11.82)
                        .fill(Color.blur1)
                        .frame(width: 50, height: 50)
            )
        )
    }

    private var reactionListView: some View {
        VStack(spacing: 0) {
            ForEach(
                0..<store.reactionList.count
            ) { idx in
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.blur2)
                        .frame(width: 50, height: 50)
                }
                .onTapGesture {
                    store.send(.selectReaction(idx: idx))
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 11.82))
    }
}

#Preview {
    PeepDetailView(
        store: .init(initialState: PeepDetailStore.State()) { PeepDetailStore() }
    )
}
