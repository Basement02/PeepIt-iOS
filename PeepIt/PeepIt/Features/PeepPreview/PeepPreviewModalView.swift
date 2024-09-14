//
//  PeepPreviewModalView.swift
//  PeepIt
//
//  Created by 김민 on 9/13/24.
//

import SwiftUI
import ComposableArchitecture

struct PeepPreviewModalView: View {
    let store: StoreOf<HomeStore>

    var body: some View {
        WithViewStore(self.store, observe: {$0}) { viewStore in
            VStack {
                if viewStore.state.isScrolledDown {
                    scrollUpLabel
                        .padding(.top, 33)
                        .padding(.bottom, 16)
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 18){
                        ForEach(1...5, id: \.self) { _ in
                            PeepPreviewCell(peep: .stubPeep1)
                        }
                    }
                    .padding(.top, 37)
                    .padding(.horizontal, 18)
                }
            }
        }
    }

    private var scrollUpLabel: some View {
        Text("↑nnn개의 핍 보기 👀")
            .font(.system(size: 16, weight: .bold))
            .background {
                RoundedRectangle(cornerRadius: 100)
                    .frame(width: 194, height: 35)
                    .foregroundStyle(Color.gray)
            }
    }
}

fileprivate struct PeepPreviewCell: View {
    let peep: PeepPreview

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(Color.init(uiColor: UIColor.systemGray5))

            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "paperplane")
                    Text("현재 위치에서 \(peep.distance)km")
                    Spacer()
                }
                .font(.system(size: 18))

                hotLabel

                Spacer()

                profileView
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 22)
        }
        .frame(width: 336, height: 448)
    }

    private var hotLabel: some View {
        HStack(spacing: 6) {
            Image(systemName: "circle.fill")
                .font(.system(size: 8))
            Text("인기")
                .font(.system(size: 14))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .foregroundStyle(Color.white)
        .background {
            RoundedRectangle(cornerRadius: 100)
                .foregroundStyle(Color.black)
        }
    }

    private var profileView: some View {
        HStack(spacing: 16) {
            Circle()
                .frame(width: 38, height: 38)
                .foregroundStyle(Color.gray)

            Text("\(peep.profile.id) ∙ \(peep.uploadTime)")
                .font(.system(size: 16))
        }
    }
}

#Preview {
    PeepPreviewModalView(
        store: .init(initialState: HomeStore.State()) {
            HomeStore()
        }
    )
}
