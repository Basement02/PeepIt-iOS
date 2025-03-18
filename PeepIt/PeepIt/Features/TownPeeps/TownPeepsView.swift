//
//  TownPeepsView.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import SwiftUI
import ComposableArchitecture

struct TownPeepsView: View {
    let store: StoreOf<TownPeepsStore>

    var body: some View {
        WithPerceptionTracking {
            ZStack {
                Color.base.ignoresSafeArea()

                VStack(spacing: 0) {
                    navigationBar

                    scrollView
                }
                .frame(width: Constant.isSmallDevice ? 343 : 361)
            }
            .frame(maxWidth: .infinity)
            .ignoresSafeArea(.all, edges: .bottom)
            .background(Color.base)
            .toolbar(.hidden, for: .navigationBar)
            .onAppear { store.send(.onAppear) }
        }
    }

    private var navigationBar: some View {
        ZStack {
            HStack {
                backButton
                Spacer()
            }

            titleView
        }
        .background(Color.base)
        .frame(height: 44)
    }

    private var backButton: some View {
        BackButton {
            store.send(.backButtonTapped)
        }
    }

    private var titleView: some View {
        HStack(spacing: 2){
            Image("IconLocation")
                .resizable()
                .frame(width: 22.4, height: 22.4)
            Text("동이름")
                .pretendard(.body02)
        }
        .padding(.vertical, 9)
        .padding(.leading, 15)
        .padding(.trailing, 23)
    }

    private var hotLabel: some View {
        HStack(spacing: 0) {
            Image("IconPopular")
                .resizable()
                .frame(width: 20.16, height: 20.16)
            Text("인기")
                .pretendard(.caption02)
                .foregroundStyle(Color.base)
        }
        .padding(.leading, 5)
        .padding(.trailing, 10)
        .background(
            RoundedRectangle(cornerRadius: 100)
                .fill(Color.coreLime)
                .frame(height: 28)
        )
    }

    private var hiddenView: some View {
        GeometryReader { proxy in
            let offsetY = proxy.frame(in: .global).origin.y
            Color.clear
                .preference(
                    key: ScrollOffsetKey.self,
                    value: offsetY
                )
                .onAppear {
                    store.send(.setInitialOffsetY(offsetY))
                }
        }
        .frame(height: 0)
    }

    private var emptyView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("새로운 소식이 없어요.")
                .pretendard(.body04)
                .foregroundStyle(Color.nonOp)

            Button {
                store.send(.uploadButtonTapped)
            } label: {
                Rectangle()
                    .frame(width: 140, height: 42)
                    .hidden()
            }
            .buttonStyle(
                PressableViewButtonStyle(
                    normalView: MiniBtn(
                        title: "업로드하러 가기"
                    ),
                    pressedView: MiniBtn(
                        title: "업로드하러 가기",
                        bg: Color.gray900
                    )
                )
            )

            Spacer()
        }
        .frame(height: 480)
    }

    private var scrollView: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .fill(Color.clear)
                .frame(height: store.isRefreshing ? 76 : 0)

            Image("IconPopularWhite")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .rotationEffect(.degrees(store.isRefreshing ? 360 : 0))
                    .animation(store.isRefreshing ? foreverAnimation : .default, value: store.isRefreshing)
                    .opacity(store.isRefreshing ? 1 : 0)
                    .offset(y: 23)

            ScrollView(showsIndicators: false) {
                hiddenView
                HStack {
                    hotLabel
                    Spacer()
                }
                .padding(.top, store.isRefreshing ? 99 : 39)
                .padding(.bottom, 25)

                HStack {
                    Text("N월 N일의 인기 핍")
                        .pretendard(.title02)
                    Spacer()
                }
                .padding(.bottom, 25)

                if store.peeps.isEmpty {
                    emptyView
                } else {
                    LazyVGrid(
                        columns: [GridItem(.flexible()), GridItem(.flexible())],
                        alignment: .center,
                        spacing: 8
                    ) {
                        ForEach(0..<store.peeps.count, id: \.self) { idx in
                            WithPerceptionTracking {
                                ThumbnailPeep(peep: store.peeps[idx])
                                    .onTapGesture {
                                        store.send(
                                            .peepCellTapped(idx: idx, peeps: store.peeps)
                                        )
                                    }
                            }
                        }
                    }
                    .padding(.bottom, 11)
                }
            }
            .onPreferenceChange(ScrollOffsetKey.self) { newOffset in
                if newOffset >= 140 && !store.isRefreshing {
                    store.send(.refresh)
                } else if newOffset < 0 {
                    store.send(.refreshEnded)
                }
            }
        }
    }

    private var foreverAnimation: Animation {
      Animation.linear(duration: 2.0)
        .repeatForever(autoreverses: false)
    }
}

fileprivate struct ThumbnailPeep: View {
    let peep: Peep

    var body: some View {
        ZStack {
            Image("SampleImage")
                .resizable()

            ThumbnailLayer.primary()

            ThumbnailLayer.secondary()

            VStack {
                HStack(spacing: 0) {
                    Image("IconCommentBoldFrame")

                    Text("00")
                        .pretendard(.body02)
                        .foregroundStyle(Color.white)
                        .padding(.trailing, 5)

                    Image("IconReactionBoldFrame")

                    Text("00")
                        .pretendard(.body02)
                        .foregroundStyle(Color.white)

                    Spacer()
                }

                Spacer()

                if peep.isVideo {
                    HStack {
                        Image("IconVideo")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Spacer()
                    }
                }
            }
            .frame(width: 151, height: 218)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .frame(
            width: Constant.isSmallDevice ? 167 : 175,
            height: Constant.isSmallDevice ? 229 : 240
        )
    }
}

#Preview {
    TownPeepsView(
        store: .init(initialState: TownPeepsStore.State()) { TownPeepsStore() }
    )
}
