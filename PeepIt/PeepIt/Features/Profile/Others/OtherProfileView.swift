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
        VStack(spacing: 0) {

            PeepItNavigationBar(
                leading: backButton,
                title: "@아이디",
                trailing: elseButton
            )
            .padding(.bottom, 49.adjustedH)

            UserProfileView(profile: .stubUser2)
                .padding(.bottom, 68.adjustedH)

            Rectangle()
                .fill(Color.op)
                .frame(width: 361, height: 1)

            uploadPeepListView

            Spacer()
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .background(Color.base)
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
                        ForEach(0..<17) { _ in
                            RoundedRectangle(cornerRadius: 10)
                                .aspectRatio(9/16, contentMode: .fit)
                                .foregroundStyle(Color(uiColor: .lightGray))
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
    }
}

#Preview {
    OtherProfileView(
        store: .init(initialState: OtherProfileStore.State()) {
            OtherProfileStore()
        }
    )
}
