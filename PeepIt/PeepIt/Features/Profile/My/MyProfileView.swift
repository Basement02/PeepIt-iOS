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
                            .padding(.top, 43.adjustedH)
                            .padding(.bottom, 6.adjustedH)

                        switch store.peepTabSelection {

                        case .uploaded:
                            myPeepList

                        case .myActivity:
                            activityList
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .frame(width: 361)
            }
            .background(Color.base)
            .toolbar(.hidden, for: .navigationBar)
            .ignoresSafeArea(.all, edges: .bottom)
            .onAppear {
                store.send(.onAppear)
            }
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
            PressableButtonStyle(originImg: "UploadN", pressedImg: "UploadY")
        )
    }

    private var profileView: some View {
        ZStack(alignment: .trailing) {
            UserProfileView(
                profile: .stubUser1,
                isMine: true,
                modifyButtonAction: {
                    // TODO:
                })
        }
    }

    private var header: some View {
        VStack(spacing: 0) {
            peepTab
                .padding(.bottom, 18.4.adjustedH)
            filters
        }
        .padding(.top, 20.adjustedH)
        .padding(.bottom, 21.adjustedH)
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
    }

    @ViewBuilder
    private var filters: some View {
        switch store.peepTabSelection {

        case .uploaded:
            HStack(spacing: 5) {
                TagTab(title: "전체 000", isSelected: true)
                TagTab(title: "동이름 00", isSelected: false)
                TagTab(title: "동이름 00", isSelected: false)

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
            // TODO:
        } label: {
            Rectangle()
                .frame(width: 140, height: 38)
                .opacity(0)
        }
        .buttonStyle(
            PressableViewButtonStyle(
                normalView: MiniBtn(
                    width: 140,
                    title: "업로드하러 가기"
                ),
                pressedView: MiniBtn(
                    width: 140,
                    title: "업로드하러 가기",
                    bg: Color.gray900
                )
            )
        )
    }

    private var watchButton: some View {
        Button {
            // TODO:
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
        let columns = [
            GridItem(.flexible(), spacing: 11),
            GridItem(.flexible(), spacing: 11),
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
                        .padding(.bottom, 11)
                    }
                }
                .padding(.bottom, 29)
            } else {
                VStack(spacing: 0) {
                    peepTab
                        .padding(.bottom, 120.adjustedH)

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
        let columns = [
            GridItem(.flexible(), spacing: 11),
            GridItem(.flexible(), spacing: 11),
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
                        .padding(.bottom, 11)
                    }
                }
                .padding(.bottom, 29)

            } else {
                VStack(spacing: 0) {
                    peepTab
                        .padding(.top, 20.adjustedH)
                        .padding(.bottom, 111.adjustedH)

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
            // TODO: 화면 전환
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray900)

                Image("Subtract")
            }
            .frame(width: 113, height: 155)
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
