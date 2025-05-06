//
//  ReportModal.swift
//  PeepIt
//
//  Created by 김민 on 11/28/24.
//

import SwiftUI
import ComposableArchitecture

struct ReportModal: View {
    @Perception.Bindable var store: StoreOf<ReportStore>

    @FocusState var isFocused: Bool
    @State private var keyboardHeight: CGFloat = .zero

    var body: some View {
        WithPerceptionTracking {
            ZStack {
                if store.showModalBg {
                    Color.op
                        .onTapGesture { store.send(.closeSheet) }
                }

                ZStack(alignment: .bottom) {
                    Color.clear

                    VStack(spacing: 0) {
                        slideBar
                        content
                    }
                }
            }
            .ignoresSafeArea()
            .offset(y: store.modalOffset)
            .animation(.easeInOut(duration: 0.3), value: store.modalOffset)
            .onTapGesture { endTextEditing() }
        }
    }

    private var slideBar: some View {
        Rectangle()
            .fill(Color.base)
            .frame(height: 64)
            .roundedCorner(20, corners: [.topLeft, .topRight])
            .overlay(alignment: .top) {
                RoundedRectangle(cornerRadius: 100)
                    .fill(Color.gray600)
                    .frame(width: 60, height: 5)
                    .padding(.top, 10)
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        /// 모달 드래그 시 UI 같이 움직임
                        if value.translation.height > 0 {
                            store.send(
                                .dragOnChanged(height: value.translation.height)
                            )
                        }
                    }
                    .onEnded { value in
                        /// 100 초과 드래그 될 시 모달 내려감
                        if value.translation.height > 100 {
                            store.send(.closeSheet)
                        } else {
                            store.send(.dragOnChanged(height: 0))
                        }
                    }
            )
    }

    private var content: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack {
                    Text("어떤 문제가 있나요?")
                        .pretendard(.title02)

                    Spacer()
                }
                .padding(.bottom, 35)

                HStack {
                    Text("더욱 건전하고 활발한 핍잇의 커뮤니티 문화를\n만들어나갈 수 있도록 솔직한 의견을 공유해주세요")
                        .pretendard(.body04)

                    Spacer()
                }
                .padding(.bottom, 35)

                HStack {
                    Image("ProfileSample")
                        .resizable()
                        .frame(width: 25, height: 25)

                    Text("닉네임")
                        .pretendard(.caption01)

                    Spacer()
                }
                .padding(.bottom, 35)
                .id("scrollTarget") // ✅ 스크롤 타겟 ID

                reportSelectButton

                if store.isReasonListShowed {
                    reportReasonList
                }

                if store.selectedReportReason == ReportStore.State.ReportReasonType.other && !store.isReasonListShowed {
                    reasonWriteTextView
                        .padding(.top, 18)
                }

                Spacer()

                if store.selectedReportReason != nil && !store.isReasonListShowed {
                    shareButton
                }

                cancelButton
                    .padding(.bottom, 40)
            }
            .frame(width: 335)
            .frame(height: 711)
        }
        .frame(maxWidth: .infinity)
        .background(Color.base)
        .frame(height: 711)
    }

    private var cancelButton: some View {
        Button {
            store.send(.closeSheet)
        } label: {
            Text("취소")
                .pretendard(.caption02)
                .foregroundStyle(Color.white)
        }
        .frame(width: 44, height: 44)
    }

    private var reportSelectButton: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray700)
                .frame(height: 53)
                .roundedCorner(
                    10,
                    corners: store.isReasonListShowed ?
                    [.topLeft, .topRight]: .allCorners
                )


            HStack {
                Text(store.selectedReportReason?.rawValue ?? "신고 사유를 선택해주세요.")
                    .pretendard(.body04)
                    .foregroundStyle(
                        store.isReasonListShowed ?
                        Color.gray300 : Color.white
                    )
                    .onTapGesture {
                        store.send(.reasonSelectButtonTapped)
                    }

                Spacer()

                Image(store.isReasonListShowed ? "IconDropUp" : "IconDrop")
                    .resizable()
                    .frame(width: 25.2, height: 25.2)
            }
            .padding(.horizontal, 20)
        }
        .onTapGesture {
            store.send(.reasonSelectButtonTapped)
        }
    }

    private var reportReasonList: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray700)
                .roundedCorner(10, corners: [.bottomLeft, .bottomRight])
                .frame(height: 288)

            VStack(spacing: 0) {
                ForEach(
                    Array(
                        zip(ReportStore.State.ReportReasonType.allCases.indices,
                            ReportStore.State.ReportReasonType.allCases)
                    ),
                    id: \.0
                ) { idx, item in
                    if idx > 0 {
                        Rectangle()
                            .fill(Color.op)
                            .frame(height: 0.5)
                    }

                    reportReasonCell(
                        isSelected: store.selectedReportReason == item,
                        type: item
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        store.send(.reasonSelected(type: item))
                    }
                    .padding(.vertical, 18)

                    if idx < ReportStore.State.ReportReasonType.allCases.count - 1 {
                        Rectangle()
                            .fill(Color.op)
                            .frame(height: 0.5)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }

    private func reportReasonCell(
        isSelected: Bool,
        type: ReportStore.State.ReportReasonType
    ) -> some View {
        HStack(spacing: 5) {
            Image(
                isSelected ?
                "CheckY" : "CheckN"
            )

            Text(type.rawValue)
                .pretendard(.caption03)
                .foregroundStyle(
                    store.selectedReportReason == nil ? Color.white :
                    isSelected ? Color.white : Color.gray300
                )
            Spacer()
        }
    }

    private var reasonWriteTextView: some View {
        ZStack(alignment: .topLeading) {
            if store.reportReason.isEmpty {
                Text("문제 상황을 인지하고 대처할 수 있도록 신고 사유에 대해 자세히 설명해주세요.")
                    .foregroundStyle(Color.gray300)
                    .padding(.top, 8)
                    .padding(.leading, 4)
            }

            TextEditor(text: $store.reportReason)
                .focused($isFocused)
                .foregroundStyle(Color.white)
                .tint(Color.coreLime)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
        }
        .pretendard(.body05)
        .padding(.all, 18)
        .background(Color.gray700)
        .frame(height: 268)
        .roundedCorner(16, corners: .allCorners)
        .onTapGesture {
            isFocused = true
        }
        .id("textView")
    }

    private var shareButton: some View {
        Button {
            // TODO:
        } label: {
            Text("공유하기")
                .mainButtonStyle()
                .foregroundStyle(Color.white)
        }
        .buttonStyle(PressableButtonStyle(colorStyle: .gray900))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    ChatView(
        store: .init(initialState: ChatStore.State()) { ChatStore() }
    )
}
