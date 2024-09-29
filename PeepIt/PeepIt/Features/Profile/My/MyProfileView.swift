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
                topBar
                    .padding(.bottom, 29)

                profileView
                    .padding(.bottom, 20)

                peepTabView

                switch store.peepTabSelection {
                case .uploaded:
                    uploadPeepListView

                case .myActivity:
                    activityListView
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .toolbar(.hidden, for: .navigationBar)
            .ignoresSafeArea(.all, edges: .bottom)
            .onAppear {
                store.send(.onAppear)
            }
        }
    }

    private var topBar: some View {
        HStack {
            Button {
                store.send(.backButtonTapped)
            } label: {
                Text("뒤로")
            }

            Spacer()

            Text("아이디")

            Spacer()

            Button {

            } label: {
                Text("공유")
            }
        }
    }

    private var profileView: some View {
        ZStack(alignment: .trailing) {
            UserProfileView(profile: .stubUser1)
                .padding(.bottom, 20)

            Spacer()

            Button {
                store.send(.modifyButtonTapped)
            } label: {
                Text("수정")
            }
        }
    }

    private var peepTabView: some View {
        HStack(spacing: 0) {
            ForEach(PeepTabType.allCases, id: \.self) { tab in
                Button {
                    store.send(.peepTabTapped(selection: tab))
                } label: {
                    VStack {
                        Text(tab.title)
                            .font(.system(size: 16))
                            .padding()

                        Rectangle()
                            .frame(height: 1)
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(
                        store.peepTabSelection == tab ? Color.green : Color.black
                    )
                }
            }
        }
    }


    private var uploadPeepListView: some View {
        let columns = [
            GridItem(.flexible(), spacing: 13),
            GridItem(.flexible(), spacing: 13),
            GridItem(.flexible())
        ]

        return Group {
            if store.uploadedPeeps.count > 0 {
                HStack {
                    Text("업로드한 핍")
                    Spacer()
                    Text("\(store.uploadedPeeps.count)")
                }
                .padding(.vertical, 17)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 13) {
                        ForEach(store.uploadedPeeps, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 10)
                                .aspectRatio(9/16, contentMode: .fit)
                                .foregroundStyle(Color(uiColor: .lightGray))
                        }
                    }
                }
            } else {
                VStack(spacing: 100) {
                    Text("내가 등록한 동네 이야기를\n모아볼 수 있어요!")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 20))

                    Button {
                        store.send(.uploadButtonTapped)
                    } label: {
                        Text("핍 업로드하러 가기")
                            .font(.system(size: 16))
                    }
                }
                .padding(.top, 150)
            }
        }
    }

    private var activityListView: some View {
        VStack {
            VStack {
                HStack {
                    Text("반응한 핍 \(store.reactedPeeps.count)개")
                    Spacer()
                    Text(">")
                }
                .padding(.vertical, 17)

                HStack(spacing: 13) {
                    ForEach(store.reactedPeeps, id: \.self) { peep in
                        ReactedPeepCell(peep: peep)
                            .aspectRatio(9/16, contentMode: .fit)
                            .frame(width: (Constant.screenWidth - (24+26))/3)
                    }

                    Spacer()
                }
            }

            VStack {
                HStack {
                    Text("댓글단 핍 \(store.commentedPeeps.count)개")
                    Spacer()
                    Text(">")
                }
                .padding(.vertical, 17)

                HStack(spacing: 13) {
                    ForEach(store.commentedPeeps, id: \.self) { peep in
                        CommentedPeepCell(peep: peep)
                            .aspectRatio(9/16, contentMode: .fit)
                            .frame(width: (Constant.screenWidth - (24+26))/3)
                    }

                    Spacer()
                }
            }
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
