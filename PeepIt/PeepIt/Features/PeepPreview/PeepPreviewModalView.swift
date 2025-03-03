//
//  PeepPreviewModalView.swift
//  PeepIt
//
//  Created by 김민 on 9/13/24.
//

import SwiftUI
import UIKit
import ComposableArchitecture

struct PeepPreviewModalView: View {
    let store: StoreOf<PeepModalStore>
    let namespace: Namespace.ID

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
                                        .padding(.top, 15)
                                } else {
                                    peepScrollView
                                        .padding(.top, 24)
                                }

                                Spacer()
                            }
                        }
                        .frame(height: PeepModalStore.State.SheetType.scrollUp.height)
                        .offset(y: store.modalOffset)
                        .animation(.linear(duration: 0.2), value: store.modalOffset)
                        .gesture(
                            DragGesture(minimumDistance: 60)
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

    private var peepScrollView: some View {
        PeepPreviewCollectionView(peeps: store.peeps) { idx, pos in
            store.send(
                .peepCellTapped(idx: idx, position: pos)
            )
        }
        .background {
            if !store.showPeepDetail,
               let pos = store.selectedPosition,
               let idx = store.selectedIdx {
                backgroundImageForAnimation()
                    .offset(x: offsetForPosition(idx: idx, position: pos))
            }
        }
    }

    private func backgroundImageForAnimation(image: String = "SampleImage") -> some View {
        Image(image)
            .resizable()
            .scaledToFill()
            .frame(width: 260, height: 350)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .matchedGeometryEffect(id: "peep", in: namespace)
            .transition(.scale(scale: 1))
    }

    private func offsetForPosition(idx: Int, position: CellPosition) -> CGFloat {
        switch position {
        case .center:
            if idx == 0 {
                return -50
            } else if idx == store.peeps.count - 1 {
                return 100
            } else {
                return .zero
            }
        case .left:
            return -300
        case .right:
            return 300
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

fileprivate struct PeepPreviewCollectionView: UIViewControllerRepresentable {
    var peeps: [Peep]
    var onSelect: (Int, CellPosition) -> Void

    func makeUIViewController(context: Context) -> PeepModalCollectionViewController {
        let viewController = PeepModalCollectionViewController()
        viewController.peeps = peeps
        viewController.onSelect = onSelect
        return viewController
    }

    func updateUIViewController(_ uiViewController: PeepModalCollectionViewController, context: Context) {
        uiViewController.peeps = peeps
        uiViewController.collectionView.reloadData()
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
