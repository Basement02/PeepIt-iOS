//
//  TownPeepsView.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import SwiftUI
import ComposableArchitecture

struct TownPeepsView: View {
    let store: StoreOf<TownPeepsStore>

    var body: some View {
        VStack(spacing: 0) {
            navigationBar

            ScrollView(showsIndicators: false) {
                HStack {
                    hotLabel
                    Spacer()
                }
                .padding(.top, 39)
                .padding(.bottom, 25)

                HStack {
                    Text("N월 N일의 인기 핍")
                        .pretendard(.title02)
                    Spacer()
                }
                .padding(.bottom, 17)

                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 11),
                        GridItem(.flexible())
                    ],
                    alignment: .center,
                    spacing: 8
                ) {
                    ForEach(0..<20) { _ in
                        ThumbnailPeep()
                    }
                }
            }
            .frame(width: 337)
            .refreshable {
                // TODO: 새로 고침
            }
        }
        .frame(maxWidth: .infinity)
        .ignoresSafeArea(.all, edges: .bottom)
        .background(Color.base)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var navigationBar: some View {
        ZStack {
            HStack {
                backButton
                Spacer()
            }

            titleView
        }
        .background(Color.base)
        .padding(.horizontal, 16)
        .frame(height: 44)
    }

    private var backButton: some View {
        Button {
            // TODO:
        } label: {
            Rectangle()
                .fill(Color.clear)
                .frame(width: 33.6, height: 33.6)
        }
        .buttonStyle(
            PressableButtonStyle(originImg: "backN", pressedImg: "backY")
        )
    }

    private var titleView: some View {
        HStack(spacing: 2){
            Image("IconLocation")
                .resizable()
                .frame(width: 22.4, height: 22.4)
            Text("동이름")
                .pretendard(.body02)
        }
        .padding(.vertical, 9)
        .padding(.leading, 15)
        .padding(.trailing, 23)
    }

    private var hotLabel: some View {
        HStack(spacing: 0) {
            Image("IconPopular")
                .resizable()
                .frame(width: 20.16, height: 20.16)
            Text("인기")
                .pretendard(.caption02)
                .foregroundStyle(Color.base)
        }
        .padding(.leading, 5)
        .padding(.trailing, 10)
        .background(
            RoundedRectangle(cornerRadius: 100)
                .fill(Color.coreLime)
                .frame(height: 28)
        )
    }
}

fileprivate struct ThumbnailPeep: View {

    var body: some View {
        ZStack(alignment: .top) {

            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color.white)

            ThumbnailLayer.primary()

            ThumbnailLayer.secondary()

            HStack(spacing: 0) {
                Image("IconComment")
                    .resizable()
                    .frame(width: 20, height: 20)

                Text("00")
                    .pretendard(.body02)
                    .foregroundStyle(Color.white)
                    .padding(.trailing, 5)

                Image("IconReact")
                    .resizable()
                    .frame(width: 20, height: 20)

                Text("00")
                    .pretendard(.body02)
                    .foregroundStyle(Color.white)

                Spacer()
            }
            .padding(.top, 12)
            .padding(.leading, 15)
        }
        .frame(width: 165, height: 225)
    }


}

#Preview {
    TownPeepsView(
        store: .init(initialState: TownPeepsStore.State()) { TownPeepsStore() }
    )
}
