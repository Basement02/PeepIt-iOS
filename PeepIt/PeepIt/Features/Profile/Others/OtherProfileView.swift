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
            topBar
                .padding(.bottom, 29)

            UserProfileView(profile: .stubUser2)
                .padding(.bottom, 56)

            uploadPeepListView

            Spacer()
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .padding(.horizontal, 22)
    }

    private var topBar: some View {
        HStack {
            Button {

            } label: {
                Text("뒤로")
            }

            Spacer()

            Text("아이디")

            Spacer()

            Button {

            } label: {
                Text("더보기")
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
                        ForEach(0..<17) { _ in
                            RoundedRectangle(cornerRadius: 10)
                                .aspectRatio(9/16, contentMode: .fit)
                                .foregroundStyle(Color(uiColor: .lightGray))
                        }
                    }
                }
            } else {
                Text("아직 등록된 핍이 없어요")
                    .font(.system(size: 16))
                    .padding(.top, 100)
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
