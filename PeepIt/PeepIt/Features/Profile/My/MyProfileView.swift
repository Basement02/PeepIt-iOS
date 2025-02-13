//
//  MyProfileView.swift
//  PeepIt
//
//  Created by 김민 on 9/23/24.
//

import SwiftUI
import ComposableArchitecture

struct MyProfileView: View {
    let store: StoreOf<MyProfileStore>

    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {

                PeepItNavigationBar(
                    leading: backButton,
                    title: "@아이디",
                    trailing: shareButton
                )

                ScrollView {
                    VStack(spacing: 0) {
                        profileView
                            .padding(.top, 43)
                            .padding(.bottom, 26)

                        switch store.peepTabSelection {

                        case .uploaded:
                            myPeepList

                        case .myActivity:
                            activityList
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .frame(width: Constant.isSmallDevice ? 343 : 361)
            }
            .background(Color.base)
            .toolbar(.hidden, for: .navigationBar)
            .ignoresSafeArea(.all, edges: .bottom)
            .onAppear { store.send(.onAppear) }
        }
    }

    private var backButton: some View {
        BackButton {
            store.send(.backButtonTapped)
        }
    }

    private var shareButton: some View {
        Button {
            // TODO:
        } label: {
            Image("UploadN")
                .opacity(0)
        }
        .buttonStyle(
            PressableButtonStyle(
                originImg: "UploadN",
                pressedImg: "UploadY"
            )
        )
    }

    private var profileView: some View {
        VStack(spacing: 26) {
            Image("ProfileSample")
                .resizable()
                .scaledToFill()
                .frame(width: 91.2, height: 91.2)

            ZStack(alignment: .topTrailing) {
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
                .frame(width: Constant.isSmallDevice ? 343 : 361)
                .padding(.vertical, 7)

                NavigationLink(
                    state: RootStore.Path.State.modifyProfile(ProfileModifyStore.State())
                ) {
                    Text("편집")
                        .pretendard(.caption04)
                        .underline()
                        .foregroundStyle(Color.white)
                        .frame(width: 44, height: 44)
                }
            }
        }
    }

    private var header: some View {
        VStack(spacing: 0) {
            peepTab
                .padding(.bottom, 16)
            filters
        }
        .padding(.bottom, 11)
        .background(Color.base)
    }

    private var peepTab: some View {
        HStack(spacing: 0) {
            ForEach(PeepTabType.allCases, id: \.self) { tab in
                Button {
                    store.send(.peepTabTapped(selection: tab))
                } label: {
                    TitleTab(
                        icnSelected: tab.selectedIcn,
                        icnNotSelected: tab.notSelectedIcn,
                        title: tab.title,
                        isSelected: store.peepTabSelection == tab
                    )
                }
            }
        }
        .frame(width: Constant.isSmallDevice ? 343 : 361)
    }

    @ViewBuilder
    private var filters: some View {
        switch store.peepTabSelection {

        case .uploaded:
            HStack(spacing: 5) {
                TagTab(title: "전체 \(store.uploadedPeeps.count)", isSelected: true)

                Spacer()
            }
            .background(Color.base)

        case .myActivity:
            HStack(spacing: 5) {
                ForEach(
                    MyProfileStore.State.MyActivityType.allCases,
                    id: \.self
                ) { tab in
                    TagTab(
                        title: "\(tab.rawValue) \(store.activityPeeps.count)",
                        isSelected: tab == store.myTabFilter
                    )
                    .onTapGesture {
                        store.send(.myTabTapped(selection: tab))
                    }
                }

                Spacer()
            }
            .background(Color.base)
        }
    }

    private var uploadButton: some View {
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
    }

    private var watchButton: some View {
        Button {
            store.send(.watchButtonTapped)
        } label: {
            Rectangle()
                .frame(width: 140, height: 38)
                .opacity(0)
        }
        .buttonStyle(
            PressableViewButtonStyle(
                normalView: MiniBtn(
                    width: 140,
                    title: "구경하러 가기"
                ),
                pressedView: MiniBtn(
                    width: 140,
                    title: "구경하러 가기",
                    bg: Color.gray900
                )
            )
        )
    }

    private var myPeepList: some View {
        let spacing = Constant.isSmallDevice ? CGFloat(9) : CGFloat(11)

        let columns = [
            GridItem(.flexible(), spacing: spacing),
            GridItem(.flexible(), spacing: spacing),
            GridItem(.flexible())
        ]

        return Group {
            if store.uploadedPeeps.count > 0 {
                LazyVGrid(
                    columns: columns,
                    spacing: 0,
                    pinnedViews: [.sectionHeaders]
                ) {
                    Section(header: header) {
                        ForEach(
                            0..<store.uploadedPeeps.count+1,
                            id: \.self
                        ) { idx in
                            if idx == 0 {
                                uploadButtonThumbnail
                            } else {
                                ThumbnailProfile(peep: store.uploadedPeeps[idx-1])
                            }
                        }
                        .padding(.bottom, spacing)
                    }
                }
                .padding(.bottom, 38)
            } else {
                VStack(spacing: 0) {
                    peepTab
                        .padding(.bottom, 128)

                    Text("내가 업로드한 핍을\n모아볼 수 있어요!")
                        .pretendard(.caption03)
                        .foregroundStyle(Color.nonOp)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 30)

                    uploadButton

                    Spacer()
                }
            }
        }
    }

    private var activityList: some View {
        let spacing = Constant.isSmallDevice ? CGFloat(9) : CGFloat(11)

        let columns = [
            GridItem(.flexible(), spacing: spacing),
            GridItem(.flexible(), spacing: spacing),
            GridItem(.flexible())
        ]

        return Group {
            if store.activityPeeps.count > 0 {
                LazyVGrid(
                    columns: columns,
                    spacing: 0,
                    pinnedViews: [.sectionHeaders]
                ) {
                    Section(header: header) {
                        ForEach(
                            store.activityPeeps,
                            id: \.self
                        ) { peep in
                            ThumbnailProfile(peep: peep)
                        }
                        .padding(.bottom, spacing)
                    }
                }
                .padding(.bottom, 38)

            } else {
                VStack(spacing: 0) {
                    peepTab
                        .padding(.bottom, 111)

                    Text(
                        """
                        아직 활동이 없어요.
                        우리 동네 핍에 참여하고
                        보고 싶은 핍을 저장하세요
                        """
                    )
                    .pretendard(.caption03)
                    .foregroundStyle(Color.nonOp)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 30)

                    watchButton

                    Spacer()
                }
            }
        }
    }

    private var uploadButtonThumbnail: some View {
        Button {
            store.send(.uploadButtonTapped)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray900)

                Image("Subtract")
            }
            .frame(
                width: Constant.isSmallDevice ? 108 : 113,
                height: Constant.isSmallDevice ? 148 : 155
            )
        }
    }
}

#Preview {
    NavigationStack {
        MyProfileView(
            store: .init(initialState: MyProfileStore.State()) {
                MyProfileStore()
            }
        )
    }
}
