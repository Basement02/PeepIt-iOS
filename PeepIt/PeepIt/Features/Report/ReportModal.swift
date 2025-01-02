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

    var body: some View {
        WithPerceptionTracking {
            ZStack(alignment: .bottom) {
                Color.clear

                VStack(spacing: 0) {
                    slideBar
                    content
                }
                .frame(height: 775)
            }
            .ignoresSafeArea()
            .ignoresSafeArea(.keyboard)
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
    }

    private var content: some View {
        ZStack {
            Color.base

            VStack(spacing: 0) {
                VStack(spacing: 35) {
                    HStack {
                        Text("어떤 문제가 있나요?")
                            .pretendard(.title02)

                        Spacer()
                    }

                    HStack {
                        Text("더욱 건전하고 활발한 핍잇의 커뮤니티 문화를\n만들어나갈 수 있도록 솔직한 의견을 공유해주세요")
                            .pretendard(.body04)

                        Spacer()
                    }

                    HStack {
                        Image("ProfileSample")
                            .resizable()
                            .frame(width: 25, height: 25)

                        Text("닉네임")
                            .pretendard(.caption01)

                        Spacer()
                    }

                    VStack(spacing: 0) {
                        reportSelectButton

                        if store.isReasonListShowed {
                            reportReasonList
                        }

                        if store.selectedReportReason
                            == ReportStore.State.ReportReasonType.other
                            && !store.isReasonListShowed
                        {
                            reasonWriteTextView
                                .padding(.top, 18)
                        }
                    }
                }

                Spacer()

                if store.selectedReportReason != nil && !store.isReasonListShowed {
                    shareButton
                }

                cancelButton
            }
            .frame(width: 335)
            .padding(.bottom, 40)
        }
        .frame(height: 711)
    }

    private var cancelButton: some View {
        Button {
            store.send(.closeModal)
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
            TextEditor(text: $store.reportReason)
                .focused($isFocused)
                .foregroundStyle(Color.white)
                .tint(Color.coreLime)
                .scrollContentBackground(.hidden)
                .background(Color.clear)

            if store.reportReason.isEmpty {
                Text("문제 상황을 인지하고 대처할 수 있도록 신고 사유에 대해 자세히 설명해주세요.")
                    .opacity(isFocused ? 0 : 1)
                    .foregroundStyle(Color.gray300)
                    .padding(.top, 8)
                    .padding(.leading, 4)
            }
        }
        .pretendard(.body05)
        .padding(.all, 18)
        .background(Color.gray700)
        .frame(height: 268)
        .roundedCorner(16, corners: .allCorners)
        .onTapGesture {
            isFocused = true
        }
    }

    private var shareButton: some View {
        Button {
            // TODO:
        } label: {
            Text("공유하기")
        }
        .mainGrayButtonStyle()
    }
}

#Preview {
    NavigationStack {
        PeepDetailView(
            store: .init(initialState: PeepDetailStore.State()) {
                PeepDetailStore()
            }
        )
    }
}
