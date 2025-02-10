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
                Color.clear
                    .allowsHitTesting(false)

                VStack {
                    Spacer()
                        .allowsHitTesting(false)

                    /// 핍 미리보기 모달
                    BackdropBlurView(bgColor: .blur1, radius: 1)
                        .roundedCorner(20, corners: [.topLeft, .topRight])
                        .overlay {
                            VStack(spacing: 0) {
                                scrollIndicator
                                    .padding(.top, 10)

                                if store.isSheetScrolledDown {
                                    scrollUpLabel
                                        .padding(.top, 15.21)
                                } else {
                                    peepScrollView
                                        .padding(.top, 24.21)
                                }

                                Spacer()
                            }
                        }
                        .frame(height: 457)
                        .offset(y: store.modalOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    store.send(
                                        .modalDragged(dragHeight: value.translation.height)
                                    )
                                }
                                .onEnded { value in
                                    store.send(
                                        .modalDragEnded(dragHeight: value.translation.height)
                                    )
                                }
                        )
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }

    private var scrollIndicator: some View {
        RoundedRectangle(cornerRadius: 100)
            .fill(Color.gray400)
            .frame(width: 60, height: 5)
    }

    private var peepScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(1...5, id: \.self) { _ in
                    PeepPreviewCell(peep: .stubPeep1)
                        .frame(width: 280, height: 383)
                        .onTapGesture {
                            store.send(.peepCellTapped)
                        }
                }
            }
            .padding(.horizontal, 18)
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
        .onTapGesture {
            store.send(
                .scrollUpButtonTapped, animation: .easeInOut(duration: 0.2)
            )
        }
    }
}

fileprivate struct PeepPreviewCell: View {
    let peep: PeepPreview

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(Color.white)

            ThumbnailLayer.primary()
                .clipShape(RoundedRectangle(cornerRadius: 20))

            ThumbnailLayer.secondary()
                .clipShape(RoundedRectangle(cornerRadius: 20))

            VStack(alignment: .leading) {
                HStack(spacing: 2) {
                    Image("IconPeep")
                    Text("현재 위치에서 \(peep.distance)km")
                    Spacer()
                    hotLabel
                }
                .pretendard(.caption01)
                .foregroundStyle(Color.white)

                Spacer()

                profileView
            }
            .padding(.top, 21)
            .padding(.bottom, 19.85.adjustedH)
            .padding(.horizontal, 18)

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

            Text("hyerim")
                .pretendard(.body02)

            Spacer()

            Text("3분 전")
                .pretendard(.caption02)
        }
        .foregroundStyle(Color.white)
    }
}

#Preview {
    PeepPreviewModalView(
        store: .init(initialState: PeepModalStore.State()) {
            PeepModalStore()
        }
    )
}
