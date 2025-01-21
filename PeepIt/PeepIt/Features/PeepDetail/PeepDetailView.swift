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
            GeometryReader { proxy in
                WithPerceptionTracking {
                    ZStack(alignment: .bottom) {
                        Color.base.ignoresSafeArea()

                        VStack(spacing: 11) {
                            topBar
                                .opacity(0)
                            peepView
                            Spacer()
                        }
                        .ignoresSafeArea(.all, edges: .bottom)

                        BackImageLayer.secondary()
                            .ignoresSafeArea()

                        VStack {
                            topBar
                            Spacer()
                            detailView
                                .padding(.horizontal, 16)
                                .padding(.bottom, 84)
                        }
                        .toolbar(.hidden, for: .navigationBar)
                        .ignoresSafeArea(.all, edges: .bottom)

                        /// 상단 우측 더보기 메뉴
                        if store.state.showElseMenu {
                            VStack {
                                HStack {
                                    Spacer()
                                    ElseMenuView(
                                        firstButton: shareButton,
                                        secondButton: reportButton,
                                        bgColor: Color.blur2
                                    )
                                    .padding(.top, 70)
                                    .padding(.trailing, 33)
                                }
                                Spacer()
                            }
                        }

                        if store.showChat {
                            ChatView(
                                store: store.scope(
                                    state: \.chatState,
                                    action: \.chatAction
                                )
                            )
                        }

                        /// 신고 모달 오픈 시 bg
                        if store.isReportSheetVisible {
                            Color.op
                                .ignoresSafeArea()
                                .onTapGesture {
                                    store.send(.closeReportSheet)
                                }
                        }

                        /// 신고 모달
//                        ReportModal(
//                            store: store.scope(
//                                state: \.report,
//                                action: \.report
//                            )
//                        )
//                        .frame(maxWidth: .infinity)
//                        .offset(y: -1000)
//                        .animation(
//                            .easeInOut(duration: 0.3),
//                            value: store.isReportSheetVisible
//                        )

                    }
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                    .onAppear { store.send(.onAppear) }
                }
            }
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
        .padding(.horizontal, 16)
    }

    private var backButton: some View {
        BackButton { store.send(.backButtonTapped) }
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
                .resizable()
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
            store.send(.reportButtonTapped)
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

    /// TODO: 이미지로 수정
    private var peepView: some View {
        Rectangle()
            .fill(Color.white)
            .aspectRatio(9/16, contentMode: .fit)
            .frame(width: Constant.screenWidth)
            .clipShape(RoundedRectangle(cornerRadius: 24))
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
                if store.showReactionList {
                    reactionListView
                } else {
                    initialReactionView
                }

                chattingButton
            }
        }
    }

    private var nameView: some View {
        NavigationLink(
            state: RootStore.Path.State.otherProfile(OtherProfileStore.State())
        ) {
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
            .foregroundStyle(Color.white)
        }
    }

    private var chattingButton: some View {
        Button {
            store.send(.showChat)
        } label: {
            Image("IconMessage")
                .resizable()
                .frame(width: 29.66, height: 29.66)
        }
        .buttonStyle(
            PressableViewButtonStyle(
                normalView: RoundedRectangle(cornerRadius: 13.95).fill(Color.blur2),
                pressedView: RoundedRectangle(cornerRadius: 13.95).fill(Color.blur1)
            )
        )
        .frame(width: 50, height: 50)
    }

    @ViewBuilder
    private var initialReactionView: some View {
        if let selectedReaction = store.selectedReaction {
            RoundedRectangle(cornerRadius: 11.82)
                .fill(Color.coreLimeOp)
                .frame(width: 50, height: 50)
                .overlay {
                    Text(selectedReaction.rawValue)
                        .font(.system(size: 24))
                }
                .onTapGesture {
                    store.send(.initialReactionButtonTapped)
                }
        } else {
            Button {
                store.send(.initialReactionButtonTapped)
            } label: {
                Rectangle()
                    .frame(width: 50, height: 50)
                    .hidden()
            }
            .buttonStyle(
                PressableViewButtonStyle(
                    normalView: RoundedRectangle(cornerRadius: 11.82).fill(Color.blur2),
                    pressedView: RoundedRectangle(cornerRadius: 11.82).fill(Color.blur1)
                )
            )
            .frame(width: 50, height: 50)
            .overlay {
                Text(store.reactionList[store.showingReactionIdx].rawValue)
                    .font(.system(size: 24))
            }
        }
    }

    private var reactionListView: some View {
        ZStack {
            Rectangle()
                .fill(Color.blur2)
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
                                .frame(width: 33.9, height: 0.42)
                        }
                    }
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 11.82))
    }

    @ViewBuilder
    private func reactionCell(
        reaction: PeepDetailStore.State.ReactionType
    ) -> some View{
        if store.selectedReaction == reaction {
            Button {
                store.send(.selectReaction(reaction: reaction))
            } label: {
                RoundedRectangle(cornerRadius: 11.82)
                    .fill(Color.coreLimeOp)
                    .frame(width: 50, height: 50)
                    .overlay {
                        Text(reaction.rawValue)
                            .font(.system(size: 24))
                    }
            }
        } else {
            Button {
                store.send(
                    .selectReaction(reaction: reaction)
                )
            } label: {
                Rectangle()
                    .frame(width: 50, height: 50)
                    .hidden()
            }
            .buttonStyle(
                PressableViewButtonStyle(
                    normalView: RoundedRectangle(cornerRadius: 11.82)
                        .fill(Color.clear).contentShape(Rectangle()),
                    pressedView: RoundedRectangle(cornerRadius: 11.82).fill(Color.blur1)
                )
            )
            .frame(width: 50, height: 50)
            .overlay {
                Text(reaction.rawValue).font(.system(size: 24))
            }
        }
    }

    private func unselectedReactionCell(
        reaction: PeepDetailStore.State.ReactionType
    ) -> some View {
        Button {
        } label: {
            Rectangle().hidden()
        }
        .buttonStyle(
            PressableViewButtonStyle(
                normalView: RoundedRectangle(cornerRadius: 11.82).fill(Color.blur2),
                pressedView: RoundedRectangle(cornerRadius: 11.82).fill(Color.blur1)
            )
        )
        .frame(width: 50, height: 50)
        .overlay {
            Text(reaction.rawValue)
                .font(.system(size: 24))
        }
    }

}

#Preview {
    NavigationStack {
        PeepDetailView(
            store: .init(initialState: PeepDetailStore.State()) {
                PeepDetailStore()
            }
        )
    }
}
