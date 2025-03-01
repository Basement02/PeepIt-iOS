//
//  PeepPreviewModalView.swift
//  PeepIt
//
//  Created by 김민 on 9/13/24.
//

import SwiftUI
import ComposableArchitecture

struct PeepPreviewModalView: View {
    @Perception.Bindable var store: StoreOf<PeepModalStore>
    let namespace: Namespace.ID

    @State private var offsetX: CGFloat = .zero

    @State private var isDragging: Bool = false
    @State private var totalDrag: CGFloat = 0.0

    var body: some View {
        WithPerceptionTracking {
            ZStack {
                Color.clear
                    .allowsHitTesting(false)

                VStack {
                    Spacer()
                        .allowsHitTesting(false)

                    /// 핍 미리보기 모달
                    BackdropBlurView(bgColor: .base.opacity(0.9), radius: 1)
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
                        .frame(height: PeepModalStore.State.SheetType.scrollUp.height)
                        .offset(y: store.modalOffset)
                        .animation(.linear(duration: 0.2), value: store.modalOffset)
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
            .onAppear { store.send(.onAppear) }
        }
    }

    private var scrollIndicator: some View {
        RoundedRectangle(cornerRadius: 100)
            .fill(Color.gray600)
            .frame(width: 60, height: 5)
    }

    private var hiddenView: some View {
        GeometryReader { proxy in
            let offsetX = proxy.frame(in: .global).origin.x
            Color.clear
                .preference(
                    key: ScrollOffsetKey.self,
                    value: offsetX
                )
                .onAppear {
                    store.send(.setPeepScrollOffset(offsetX))
                }
        }
        .frame(height: 0)
    }

    private var peepScrollView: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                hiddenView
                LazyHStack(spacing: 10) {
                    ForEach(0..<store.peeps.count, id: \.self) { idx in
                        PeepPreviewCell(peep: store.peeps[idx])
                            .id(idx)
                            .onTapGesture {
                                store.send(
                                    .peepCellTapped(idx: idx, peeps: store.peeps),
                                    animation: .linear(duration: 0.1)
                                )
                            }
                            .background {
                                if !store.showPeepDetail {
                                    Image("SampleImage")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 280, height: 383)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .matchedGeometryEffect(id: "peep\(idx)", in: namespace)
                                        .transition(.scale(scale: 1))
                                }
                            }
                    }
                }
                .padding(.horizontal, 18)
            }
            .frame(height: 383)
        }
    }

    private var scrollUpLabel: some View {
        Button {
            store.send(.scrollUpButtonTapped)
        } label: {
            HStack(spacing: 6) {
                Image("IconUp")
                Text("nnn개의 핍 보기")
                    .pretendard(.body04)

                Image("IconEyes")
            }
            .padding(.leading, 20)
            .padding(.trailing, 15)
            .frame(height: 36)
        }
        .buttonStyle(PressableButtonStyle(colorStyle: .base))
        .clipShape(RoundedRectangle(cornerRadius: 100))
    }
}

fileprivate struct PeepPreviewCell: View {
    let peep: Peep

    var body: some View {
        ZStack(alignment: .leading) {
            Image("SampleImage")
                .resizable()
                .scaledToFill()
                .foregroundStyle(Color.white)

            ThumbnailLayer.primary()
                .clipShape(RoundedRectangle(cornerRadius: 20))

            ThumbnailLayer.secondary()
                .clipShape(RoundedRectangle(cornerRadius: 20))

            VStack(alignment: .leading) {
                HStack(spacing: 2) {
                    Image("IconPeep")
                    Text("현재 위치에서 4km")
                    Spacer()
                    hotLabel
                }
                .pretendard(.body05)
                .foregroundStyle(Color.white)

                Spacer()

                profileView
            }
            .padding(.top, 19)
            .padding(.bottom, 20)
            .frame(width: 250)
            .padding(.leading, 16)
            // TODO: - 활성화 핍 border
        }
        .frame(width: 281, height: 384)
        .clipShape(RoundedRectangle(cornerRadius: 20))
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
                .frame(width: 25, height: 25)

            Text("hyerim")
                .pretendard(.body02)

            Spacer()

            Text("3분 전")
                .pretendard(.caption04)
        }
        .foregroundStyle(Color.white)
    }
}

#Preview {
    @Namespace var namespaceStub

    return PeepPreviewModalView(
        store: .init(initialState: PeepModalStore.State()) {
            PeepModalStore()
        },
        namespace: namespaceStub
    )
}
