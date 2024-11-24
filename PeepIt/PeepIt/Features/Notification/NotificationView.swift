//
//  NotificationView.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import SwiftUI
import ComposableArchitecture

struct NotificationView: View {
    let store: StoreOf<NotificationStore>

    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                PeepItNavigationBar(
                    leading: backButton,
                    title: "내 소식"
                )
                .padding(.bottom, 39.adjustedH)

                Group {
                    myActivePeepList
                        .padding(.bottom, 25.adjustedH)

                    divider
                        .padding(.bottom, 25.adjustedH)

                    notificationList
                }
                .frame(width: 337)

                Spacer()
            }
            .background(Color.base)
            .toolbar(.hidden, for: .navigationBar)
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }

    private var backButton: some View {
        BackButton {
            // TODO:
        }
    }

    private var myActivePeepList: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(0..<5) { _ in
                    ThumbnailAlarm()
                }
            }
        }
        .scrollIndicators(.hidden)
    }

    private var divider: some View {
        Rectangle()
            .fill(Color.op)
            .frame(height: 1)
    }

    private var notificationList: some View {
        List(0..<10) { _ in
            NotificationCell()
                .listRowInsets(EdgeInsets())
                .background(Color.base)
        }
        .listRowSpacing(15)
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
}

fileprivate struct NotificationCell: View {

    var body: some View {
        HStack {
            Spacer()

            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray900)

                HStack(spacing: 14) {
                    RoundedRectangle(cornerRadius: 3)
                        .frame(width: 44, height: 60)
                        .overlay {
                            ThumbnailLayer.primary()
                            ThumbnailLayer.secondary()
                        }

                    VStack(alignment: .leading, spacing: 2.5) {
                        Text("{아이디}님의 핍이 인기를 얻고 있어요!")
                            .pretendard(.body04)
                            .foregroundStyle(Color.gray100)
    
                        Text("")
                            .pretendard(.caption03)
                            .foregroundStyle(Color.nonOp)
    
                        Text("3분 전")
                            .pretendard(.caption01)
                            .foregroundStyle(Color.nonOp)
                    }
                    .lineLimit(1)

                    Spacer()
                }
                .frame(width: 317, height: 60)
                .padding(.vertical, 9)
                .padding(.horizontal, 10)
            }

            Spacer()
        }
    }
}

#Preview {
    NotificationView(
        store: .init(initialState: NotificationStore.State()) { NotificationStore()
        }
    )
}
