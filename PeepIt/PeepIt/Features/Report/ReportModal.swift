//
//  ReportModal.swift
//  PeepIt
//
//  Created by 김민 on 11/28/24.
//

import SwiftUI
import ComposableArchitecture

struct ReportModal: View {
    let store: StoreOf<ReportStore>

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

    //            reportSelectButton

                reportReasonList

                Spacer()

                cancelButton
                    .padding(.bottom, 40)
            }
            .frame(width: 335)
        }
        .frame(height: 711)
    }

    private var cancelButton: some View {
        Button {
            // TODO:
        } label: {
            Text("취소")
                .pretendard(.caption02)
                .foregroundStyle(Color.white)
        }
        .frame(width: 44, height: 44)
    }

    private var reportSelectButton: some View {
        HStack {
            Text("신고 사유를 선택해주세요.")
                .pretendard(.body04)
            Spacer()

            Image("IconDrop")
                .resizable()
                .frame(width: 25.2, height: 25.2)
        }
        .padding(.horizontal, 20)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray700)
                .frame(height: 53)
        }
    }

    private var reportReasonList: some View {
        VStack(spacing: 33) {
            HStack {
                Text("신고 사유를 선택해주세요.")
                    .pretendard(.body04)
                    .foregroundStyle(Color.gray300)
                Spacer()

                Image("IconDropUp")
            }
            .padding(.top, 14)

            VStack(spacing: 0) {
                ForEach(0..<5) { idx in

                    if idx > 0 {
                        Rectangle()
                            .fill(Color.op)
                            .frame(height: 0.5)
                            .padding(.bottom, 18)
                    }

                    HStack {
                        Text("부적절한 내용을 업로드해요")
                            .pretendard(.caption03)
                        Spacer()
                    }

                    if idx < 4 {
                        Rectangle()
                            .fill(Color.op)
                            .frame(height: 0.5)
                            .padding(.top, 18)
                    }
                }
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray700)
                .frame(height: 341)
        )
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
