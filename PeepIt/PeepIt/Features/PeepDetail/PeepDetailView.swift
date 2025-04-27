//
//  PeepDetailView.swift
//  PeepIt
//
//  Created by 김민 on 9/16/24.
//

import SwiftUI
import ComposableArchitecture

struct PeepDetailView: View {
    @Perception.Bindable var store: StoreOf<PeepDetailStore>

    var body: some View {
        WithPerceptionTracking {
            GeometryReader { proxy in
                WithPerceptionTracking {
                    ZStack {
                        if store.showPeepDetailBg {
                            Color.base.ignoresSafeArea()
                        } else {
                            Color.clear.ignoresSafeArea()
                        }

                        /// 페이징되는 요소들
                        TabView(selection: $store.currentIdx) {
                            ForEach(
                                Array(
                                    zip(store.peepIdList.indices,
                                        store.peepIdList)
                                ), id: \.0) { idx, id in
                                WithPerceptionTracking {
                                    ZStack {
                                        if let peep = store.peeps[safe: idx],
                                            let peepContent = peep {
                                            /// 뒷 배경 사진 레이아웃
                                            VStack(spacing: 11) {
                                                Spacer().frame(height: 44)

                                                AsyncStoryImage(
                                                    dataURLStr: peepContent.data,
                                                    isVideo: peepContent.isVideo
                                                )
                                                .highPriorityGesture(
                                                    TapGesture()
                                                        .onEnded { store.send(.viewTapped) }
                                                )

                                                Spacer()
                                            }
                                            .ignoresSafeArea(.all, edges: .bottom)

                                            BackImageLayer.secondary()
                                                .ignoresSafeArea()
                                                .allowsHitTesting(false)

                                            /// 진입 애니메이션 처리 여부
                                            if store.showPeepDetailObject {
                                                /// 앞 오브젝트
                                                VStack {
                                                    Spacer()
                                                    detailView(peep: peepContent)
                                                        .padding(.horizontal, 16)
                                                        .padding(.bottom, 84)
                                                }
                                                .ignoresSafeArea()
                                            }

                                        } else {
                                            Color.base
                                                .ignoresSafeArea()
                                        }
                                    }
                                    .tag(idx)
                                }
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))

                        /// 상단바 - 탭뷰와 같이 안 움직이고 고정됨
                        if store.showPeepDetailObject {
                            VStack {
                                topBar
                                Spacer()
                            }
                        }
                    }
                    .ignoresSafeArea(.all, edges: .bottom)
                    .toolbar(.hidden, for: .navigationBar)
                    .onAppear { store.send(.onAppear) }
                    .overlay(alignment: .topTrailing) {
                        /// 상단 우측 더보기 메뉴
                        if store.state.showElseMenu {
                            ElseMenuView(
                                firstButton: shareButton,
                                secondButton: reportButton,
                                bgColor: Color.blur2
                            )
                            .padding(.top, 69)
                            .padding(.trailing, 36)
                        }
                    }
                    .overlay(alignment: .bottom) {
                        /// 신고 모달 오픈 시 bg
                        if store.isReportSheetVisible {
                            Color.op
                                .ignoresSafeArea()
                                .onTapGesture {
                                    store.send(.closeReportSheet)
                                }
                        }

                        /// 신고 모달
                        ReportModal(
                            store: store.scope(
                                state: \.report,
                                action: \.report
                            )
                        )
                        .ignoresSafeArea()
                        .frame(maxWidth: .infinity)
                        .offset(y: store.modalOffset)
                        .animation(
                            .easeInOut(duration: 0.3),
                            value: store.isReportSheetVisible
                        )
                    }
                    .overlay {
                        /// 채팅 상세
                        if store.showChat {
                            ChatView(
                                store: store.scope(
                                    state: \.chatState,
                                    action: \.chatAction
                                )
                            )
                        }
                    }
                    .sheet(isPresented: $store.showShareSheet) {
                        ShareSheet(activityItems: ["핍 공유하기"])
                            .presentationDetents([.medium])
                            .ignoresSafeArea()
                    }
                }
            }
        }
    }
}

extension PeepDetailView {

    private var topBar: some View {
        HStack {
            BackButton {
                store.send(.backButtonTapped, animation: .linear(duration: 0.1))
            }

            Spacer()

            locationButton

            Spacer()
            moreButton
        }
        .frame(height: 44)
        .padding(.horizontal, 16)
    }

    private var moreButton: some View {
        Button {
            store.send(.setShowingElseMenu(!store.showElseMenu))
        } label: {
            Image("IconElse")
                .resizable()
                .frame(width: 33.6, height: 33.6)
        }
    }

    private var locationButton: some View {
        HStack(spacing: 2) {
            Image("IconLocation")
                .resizable()
                .frame(width: 22.4, height: 22.4)

            Text((store.topLocations[safe: store.currentIdx] ?? "") ?? "")
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
            store.send(.shareButtonTapped)
        } label: {
            HStack(spacing: 3) {
                Image("CombiShareBtnN")
                Text("공유하기")
            }
            .pretendard(.body02)
            .foregroundStyle(Color.white)
        }
    }

    private var reportButton: some View {
        Button {
            store.send(.reportButtonTapped)
        } label: {
            HStack(spacing: 3) {
                Image("CombiReportBtnN")
                Text("신고하기")
            }
            .pretendard(.body02)
            .foregroundStyle(Color.coreRed)
        }
    }

    private func detailView(peep: Peep) -> some View {
        HStack(alignment: .bottom, spacing: 12) {
            VStack(spacing: 9) {
                NavigationLink(
                    state: RootStore.Path.State.otherProfile(OtherProfileStore.State())
                ) {
                    HStack {
                        AsyncProfile(profileUrlStr: peep.profileUrl)
                            .frame(width: 37.62, height: 37.62)
                            .clipShape(RoundedRectangle(cornerRadius: 8))

                        Text(peep.writerId)
                            .pretendard(.headline)

                        Text(peep.uploadAt)
                            .pretendard(.caption04)

                        Spacer()
                    }
                    .foregroundStyle(Color.white)
                }

                HStack {
                    Text(peep.content.forceCharWrapping)
                        .pretendard(.body03)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .truncationMode(.tail)
                    Spacer()
                }
                .frame(height: 50, alignment: .topLeading)
            }

            VStack(spacing: 15) {
                if store.showReactionList {
                    reactionListView
                } else {
                    initialReactionView(peep: peep)
                }

                chattingButton
            }
        }
    }

    private var chattingButton: some View {
        Button {

        } label: {
            Image("IconMessage")
                .resizable()
                .frame(width: 29.66, height: 29.66)
        }
        .frame(width: 50, height: 50)
        .background(Color.blur1)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .highPriorityGesture(
            TapGesture()
                .onEnded { store.send(.showChat) }
        )
    }

    private func initialReactionView(peep: Peep) -> some View {
        if let selectedReaction = peep.reaction {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.coreLimeOp)
                .frame(width: 50, height: 50)
                .overlay {
                    Text(selectedReaction)
                        .font(.system(size: 24))
                }
                .highPriorityGesture(
                    TapGesture()
                        .onEnded { store.send(.initialReactionButtonTapped) }
                )
        } else {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blur2)
                .frame(width: 50, height: 50)
                .overlay {
                    Text(store.reactionList[store.showingReactionIdx].rawValue)
                        .font(.system(size: 24))
                }
                .highPriorityGesture(
                    TapGesture()
                        .onEnded { store.send(.initialReactionButtonTapped) }
                )
        }
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
        reaction: PeepDetailStore.State.ReactionType
    ) -> some View{
        if store.peepList[store.currentIdx].reaction == reaction.rawValue {
            Button {

            } label: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.coreLimeOp)
                    .frame(width: 50, height: 50)
                    .overlay {
                        Text(reaction.rawValue)
                            .font(.system(size: 24))
                    }
            }
            .highPriorityGesture(
                TapGesture()
                    .onEnded { store.send(.selectReaction(reaction: reaction)) }
            )
        } else {
            Button {

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
            .highPriorityGesture(
                TapGesture()
                    .onEnded { store.send(.selectReaction(reaction: reaction)) }
            )
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
