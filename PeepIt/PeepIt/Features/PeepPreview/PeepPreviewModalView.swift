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
    @Perception.Bindable var store: StoreOf<PeepModalStore>
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
                                if store.peeps.isEmpty {
                                    emptyScrollLabel
                                        .padding(.top, 30)
                                    Spacer()
                                } else {
                                    scrollIndicator
                                        .padding(.top, 10)

                                    if store.isSheetScrolledDown {
                                        scrollUpLabel
                                            .padding(.top, 15)
                                    } else {
                                        peepScrollView
                                            .padding(.top, 24)
                                    }
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
                                    if store.peeps.count > 0 {
                                        store.send(
                                            .modalDragged(dragHeight: value.translation.height)
                                        )
                                    }
                                }
                                .onEnded { value in
                                    if store.peeps.count > 0 {
                                        store.send(
                                            .modalDragEnded(dragHeight: value.translation.height)
                                        )
                                    }
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

    private var emptyScrollLabel: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 100)
                .fill(Color.base)
                .frame(width: 165, height: 36)

            Text("아직 새로운 핍이 없어요")
                .pretendard(.body04)
        }
    }

    private var peepScrollView: some View {
        PeepPreviewCollectionView(
            peeps: store.peeps,
            scrollToIndex: $store.scrollToIdx
        ) { idx, pos in
            store.send(
                .peepCellTapped(idx: idx, position: pos)
            )
        }
        .frame(height: 384)
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
                return -30
            } else if idx == store.peeps.count - 1 {
                return 30
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
                Text("\(store.peeps.count)개의 핍 보기")
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
    @Binding var scrollToIndex: Int?
    
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

        if let index = scrollToIndex {
            uiViewController.scrollToItem(at: index)
            DispatchQueue.main.async {
                scrollToIndex = nil
            }
        }
    }
}
