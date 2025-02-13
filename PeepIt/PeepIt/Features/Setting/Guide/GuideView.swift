//
//  GuideView.swift
//  PeepIt
//
//  Created by 김민 on 11/22/24.
//

import SwiftUI
import ComposableArchitecture

struct GuideView: View {
    @Perception.Bindable var store: StoreOf<GuideStore>

    var body: some View {
        VStack(spacing: 0) {
            PeepItNavigationBar(
                leading: backButton,
                title: "이용 안내"
            )
            .padding(.bottom, 39)

            Group {
                lastUpdateView
                    .padding(.bottom, 24)

                guideList
            }
            .padding(.horizontal, 29)

            Spacer()
        }
        .background(Color.base)
        .ignoresSafeArea(.all, edges: .bottom)
        .toolbar(.hidden, for: .navigationBar)
        .fullScreenCover(isPresented: $store.isSheetVisible) { 
            GuideDescriptionView(store: self.store)
        }
    }

    private var backButton: some View {
        BackButton {
            store.send(.backButtonTapped)
        }
    }

    private var lastUpdateView: some View {
        HStack {
            Spacer()
            Text("YY.MM.DD 마지막 업데이트")
                .pretendard(.body04)
                .foregroundStyle(Color.gray400)
        }
    }

    private func listCell(title: String) -> some View {
        HStack {
            Text(title)
                .pretendard(.foodnote)
            Spacer()
            Image("IconGolink")
                .resizable()
                .frame(width: 21, height: 21)
        }
        .contentShape(Rectangle())
    }

    private var guideList: some View {
        ForEach(
            Array(zip(GuideStore.State.GuideType.allCases.indices,
                      GuideStore.State.GuideType.allCases)
            ), id: \.0
        ) { idx, item in
            listCell(title: item.rawValue)
                .onTapGesture {
                    store.send(.guideCellTapped(type: item))
                }
                .padding(
                    .bottom,
                    idx == GuideStore.State.GuideType.allCases.count-1 ?
                    0 : 32
                )
        }
    }
}

#Preview {
    GuideView(
        store: .init(initialState: GuideStore.State()) {
            GuideStore()
        }
    )
}
