//
//  OtherProfileView.swift
//  PeepIt
//
//  Created by 김민 on 9/24/24.
//

import SwiftUI
import ComposableArchitecture

struct OtherProfileView: View {
    @Perception.Bindable var store: StoreOf<OtherProfileStore>

    var body: some View {
        WithPerceptionTracking {
            ZStack(alignment: .topTrailing) {
                Color.base
                    .ignoresSafeArea()

                VStack(spacing: 0) {

                    PeepItNavigationBar(
                        leading: backButton,
                        title: "@아이디",
                        trailing: elseButton
                    )
                    .padding(.bottom, 43)

                    profileView
                        .padding(.bottom, 61)

                    Rectangle()
                        .fill(Color.op)
                        .frame(
                            width: Constant.isSmallDevice ? 343 : 361,
                            height: 1
                        )

                    if store.isUserBlocked {
                        blockedView
                            .padding(.top, 26)
                    } else {
                        uploadPeepListView
                    }

                    Spacer()
                }

                /// 더보기 버튼
                if store.isElseButtonTapped {
                    ElseMenuView(
                        firstButton: shareButton,
                        secondButton: blockButton,
                        bgColor: .gray800
                    )
                    .padding(.top, 59)
                    .padding(.trailing, 36)
                }

                /// 차단 안내문 모달 배경
                if store.isModalVisible {
                    Color.op
                        .ignoresSafeArea()
                        .onTapGesture {
                            store.send(.closeModal)
                        }
                }

                /// 차단 안내문 모달
                VStack {
                    Spacer()
                    BlockDescriptionModal(store: self.store)
                        .frame(height: 670)
                        .offset(y: store.modalOffset)
                        .animation(
                            .easeInOut(duration: 0.3),
                            value: store.isModalVisible
                        )
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let newOffset = value.translation.height
                                    store.send(.modalDragChanged(offset: newOffset))
                                }
                                .onEnded { _ in store.send(.modalDragEnded) }
                        )
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .toolbar(.hidden, for: .navigationBar)
            .onAppear { store.send(.onAppear) }
            .onTapGesture { store.send(.viewTapped) }
            .sheet(isPresented: $store.showShareSheet) {
                ShareSheet(activityItems: ["핍 공유하기"])
                    .presentationDetents([.medium])
                    .ignoresSafeArea()
            }
        }
    }

    private var backButton: some View {
        BackButton {
            store.send(.backButtonTapped)
        }
    }

    private var elseButton: some View {
        Button {
            store.send(.elseButtonTapped(!store.isElseButtonTapped))
        } label: {
            Image("ElseN")
                .resizable()
                .frame(width: 33.6, height: 33.6)
        }
    }

    private var profileView: some View {
        VStack(spacing: 26) {
            Image("ProfileSample")
                .resizable()
                .scaledToFill()
                .frame(width: 91.2, height: 91.2)

            VStack(spacing: 11) {
                Text("${닉네임}")
                    .pretendard(.title02)

                HStack(spacing: 2) {
                    Image("IconLocation")
                        .resizable()
                        .frame(width: 22.4, height: 22.4)
                    Text("동이름")
                        .pretendard(.body02)
                }
            }
            .padding(.vertical, 7)
        }
    }

    private var uploadPeepListView: some View {
        let spacing = Constant.isSmallDevice ? CGFloat(9) : CGFloat(11)
        let columns = [
            GridItem(.flexible(), spacing: spacing),
            GridItem(.flexible(), spacing: spacing),
            GridItem(.flexible())
        ]

        return Group {
            if store.uploadedPeeps.count > 0 {
                HStack(spacing: 5) {
                    TagTab(title: "전체 00", isSelected: true)
                    TagTab(title: "동이름 00", isSelected: false)
                    TagTab(title: "동이름 00", isSelected: false)

                    Spacer()
                }
                .padding(.top, 18.4)
                .padding(.bottom, 11)

                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: spacing) {
                        ForEach(
                            store.uploadedPeeps
                        ) { peep in
                            ThumbnailProfile(peep: peep)
                        }
                    }
                    .padding(.bottom, 38)
                }
            } else {
                Text("아직 등록된 핍이 없어요.")
                    .pretendard(.body04)
                    .foregroundStyle(Color.nonOp)
                    .padding(.top, 161)
            }
        }
        .frame(width: Constant.isSmallDevice ? 343 : 361)
    }

    private var shareButton: some View {
        Button {
            store.send(.shareButtonTapped)
        } label: {
            HStack(spacing: 3) {
                Image("CombiShareBtnN")
                Text("공유하기")
            }
            .foregroundStyle(Color.white)
            .pretendard(.body02)
        }
    }

    private var blockButton: some View {
        Button {
            store.send(.elseBlockButtonTapped)
        } label: {
            HStack(spacing: 3) {
                Image("CombiBlockBtnN")
                Text(store.isUserBlocked ? "차단해제" : "차단하기")
            }
            .foregroundStyle(Color.coreRed)
            .pretendard(.body02)
        }
    }

    private var blockedView: some View {
        HStack(spacing: 2) {
            Image("IconBlocked")

            Text("해당 계정은 회원님에 의해 차단된 계정입니다.")
                .foregroundStyle(Color.white)
                .pretendard(.body04)

            Spacer()
        }
        .padding(.leading, 15)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color.coreRed)
        )
        .frame(width: 349)
    }
}

#Preview {
    OtherProfileView(
        store: .init(initialState: OtherProfileStore.State()) {
            OtherProfileStore()
        }
    )
}
