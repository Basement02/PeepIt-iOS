//
//  PeepPreviewModalView.swift
//  PeepIt
//
//  Created by 김민 on 9/13/24.
//

import SwiftUI
import ComposableArchitecture

struct PeepPreviewModalView: View {
    let store: StoreOf<PeepModalStore>

    var body: some View {
        WithPerceptionTracking {
            ZStack {
                Color.blur1

                VStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 100)
                        .frame(width: 60, height: 5)
                        .foregroundStyle(Color.gray400)
                        .padding(.top, 10)

                    if store.isSheetScrolledDown {
                        scrollUpLabel
                            .padding(.top, 15.21)
                    }

                    if !store.isSheetScrolledDown {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10){
                                ForEach(1...5, id: \.self) { _ in
                                    PeepPreviewCell(peep: .stubPeep1)
                                        .frame(width: 280, height: 384)
                                        .onTapGesture {
                                            store.send(.peepCellTapped)
                                        }
                                }
                            }
                            .padding(.top, 24.21)
                            .padding(.horizontal, 18)
                        }
                    }

                    Spacer()
                }
            }
            .ignoresSafeArea()
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }

    private var scrollUpLabel: some View {
        HStack(spacing: 6) {
            Image("IconUp")
            Text("nnn개의 핍 보기")
                .pretendard(.body04)

            Image("IconEyes")
        }
        .padding(.leading, 20)
        .padding(.trailing, 15)
        .background(
            RoundedRectangle(cornerRadius: 100)
                .fill(Color.base)
                .frame(height: 36)
        )
    }
}

fileprivate struct PeepPreviewCell: View {
    let peep: PeepPreview

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(Color.init(uiColor: UIColor.systemGray5))

            VStack(alignment: .leading) {
                HStack(spacing: 2) {
                    Image("IconPeep")
                    Text("현재 위치에서 \(peep.distance)km")
                    Spacer()
                    hotLabel
                }
                .pretendard(.caption03)
                .foregroundStyle(Color.white)


                Spacer()

                profileView
            }
            .padding(.top, 21.adjustedH)
            .padding(.bottom, 19.85.adjustedH)
            .padding(.horizontal, 18.adjustedW)

        }
    }

    private var hotLabel: some View {
        HStack(spacing: 0) {
            Image("IconPopular")
            Text("인기")
                .pretendard(.caption02)
                .foregroundStyle((Color(hex: 0x202020)))
        }
        .padding(.leading, 6)
        .padding(.trailing, 10)
        .padding(.vertical, 3)
        .background(
            RoundedRectangle(cornerRadius: 100)
                .fill(Color.coreLime)
        )
    }

    private var profileView: some View {
        HStack {
            Image("ProfileSample")
                .resizable()
                .frame(width: 30, height: 30)

            Text("혜림")
                .pretendard(.body02)

            Spacer()

            Text("3분 전")
                .pretendard(.caption04)
        }
        .foregroundStyle(Color.white)
    }
}

#Preview {
//    PeepPreviewModalView(
//        store: .init(initialState: PeepModalStore.State()) {
//            PeepModalStore()
//        }
//    )
    HomeView(
        store: .init(initialState: HomeStore.State()) {
            HomeStore()
        }
    )
}
