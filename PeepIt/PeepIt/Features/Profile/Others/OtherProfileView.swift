//
//  OtherProfileView.swift
//  PeepIt
//
//  Created by 김민 on 9/24/24.
//

import SwiftUI
import ComposableArchitecture

struct OtherProfileView: View {
    let store: StoreOf<OtherProfileStore>

    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {

                PeepItNavigationBar(
                    leading: backButton,
                    title: "@아이디",
                    trailing: elseButton
                )
                .padding(.bottom, 43.adjustedH)

                UserProfileView(profile: .stubUser2)
                    .padding(.bottom, 68.adjustedH)

                Rectangle()
                    .fill(Color.op)
                    .frame(width: 361, height: 1)

                uploadPeepListView

                Spacer()
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .toolbar(.hidden, for: .navigationBar)
            .background(Color.base)
        }
    }

    private var backButton: some View {
        BackButton {
            // TODO:
        }
    }

    private var elseButton: some View {
        Button {
            // TODO:
        } label: {
            Rectangle()
                .fill(Color.clear)
                .frame(width: 33.6, height: 33.6)
        }
        .buttonStyle(
            PressableButtonStyle(originImg: "ElseN", pressedImg: "ElseY")
        )
    }

    private var uploadPeepListView: some View {
        let columns = [
            GridItem(.flexible(), spacing: 11),
            GridItem(.flexible(), spacing: 11),
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
                .padding(.top, 18.4.adjustedH)
                .padding(.bottom, 21.adjustedH)

                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 11) {
                        ForEach(
                            store.uploadedPeeps
                        ) { peep in
                            ThumbnailProfile(peep: peep)
                        }
                    }
                }
            } else {
                Text("아직 등록된 핍이 없어요.")
                    .pretendard(.body04)
                    .foregroundStyle(Color.nonOp)
                    .padding(.top, 161.adjustedH)
            }
        }
        .frame(width: 361)
    }
}

#Preview {
    OtherProfileView(
        store: .init(initialState: OtherProfileStore.State()) {
            OtherProfileStore()
        }
    )
}
