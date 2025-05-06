//
//  PeepDetailView.swift
//  PeepIt
//
//  Created by 김민 on 5/6/25.
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
                        Color.base.ignoresSafeArea()

                        /// 뒷 배경 사진 레이아웃
                        VStack(spacing: 11) {
                            Spacer().frame(height: 44)

                            AsyncStoryImage(
                                dataURLStr: "",
                                isVideo: true
                            )
                            .onTapGesture { store.send(.viewTapped) }

                            Spacer()
                        }
                        .ignoresSafeArea(.all, edges: .bottom)

                        BackImageLayer.secondary()
                            .ignoresSafeArea()
                            .allowsHitTesting(false)

                        VStack {
                            topBar
                            Spacer()
                            detailView(peep: .stubPeep0)
                                .padding(.bottom, 84)
                        }
                        .padding(.horizontal, 16)
                    }
                    .ignoresSafeArea(.all, edges: .bottom)
                    .toolbar(.hidden, for: .navigationBar)
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
                        /// 신고 모달
                        ReportModal(
                            store: store.scope(
                                state: \.report,
                                action: \.report
                            )
                        )
                    }
                    .overlay {
                        /// 채팅 상세
                        if store.showChat {
                            ChatView(
                                store: store.scope(
                                    state: \.chat,
                                    action: \.chat
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
            BackButton { store.send(.backButtonTapped) }

            Spacer()

            locationButton

            Spacer()
            moreButton
        }
        .frame(height: 44)
    }

    private var moreButton: some View {
        Button {
            store.send(.elseMenuButtonTapped)
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

            Text("위치")
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
                ReactionListView(
                    store: store.scope(
                        state: \.reaction,
                        action: \.reaction
                    )
                )

                chattingButton
            }
        }
    }

    private var chattingButton: some View {
        Button {
            store.send(.chatButtonTapped)
        } label: {
            Image("IconMessage")
                .resizable()
                .frame(width: 29.66, height: 29.66)
        }
        .frame(width: 50, height: 50)
        .background(Color.blur1)
        .clipShape(RoundedRectangle(cornerRadius: 14))
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


#Preview {
    NavigationStack {
        PeepDetailView(
            store: .init(initialState: PeepDetailStore.State()) {
                PeepDetailStore()
            }
        )
    }
}
