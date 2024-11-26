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
                }
                .frame(width: 337)

                notificationList

                Spacer()
            }
            .background(Color.base)
            .toolbar(.hidden, for: .navigationBar)
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }

    private var backButton: some View {
        BackButton { store.send(.backButtonTapped) }
    }

    @ViewBuilder
    private var myActivePeepList: some View {
        if store.activePeeps.count > 0 {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(store.activePeeps) { peep in
                        ThumbnailAlarm(peep: peep)
                    }
                }
            }
            .scrollIndicators(.hidden)
        } else {
            HStack {
                uploadButton
                Spacer()
            }
        }
    }

    private var divider: some View {
        Rectangle()
            .fill(Color.op)
            .frame(height: 1)
    }

    @ViewBuilder
    private var notificationList: some View {
        if store.notiList.count > 0 {
            List(store.notiList, id: \.id) { noti in
                HStack {
                    Spacer()

                    NotificationCell(notification: noti)

                    Spacer()
                }
                .listRowInsets(EdgeInsets())
                .background(Color.base)
                .swipeActions(
                    allowsFullSwipe: false
                ) {
                    Button {
                        store.send(.removeNoti(item: noti))
                    } label: {
                        Label("Delete", image: "IconTrash")
                            .tint(Color.coreRed)
                    }
                }
            }
            .listRowSpacing(15)
            .listStyle(.plain)
            .scrollIndicators(.hidden)
        } else {
            VStack {
                Spacer()

                Text("새로운 소식이 없어요.")
                    .pretendard(.body04)
                    .foregroundStyle(Color.nonOp)

                Spacer()
            }
            .frame(height: 468)
        }
    }

    private var uploadButton: some View {
        Button {
            store.send(.uploadButtonTapped)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray900)
                    .frame(width: 92, height: 126)

                Image("Subtract")
                    .resizable()
                    .frame(width: 27.31, height: 27.31)
            }
        }
    }
}

fileprivate struct NotificationCell: View {
    let notification: Notification

    var body: some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 3)
                .frame(width: 44, height: 60)
                .overlay {
                    ThumbnailLayer.primary()
                    ThumbnailLayer.secondary()
                }

            VStack(alignment: .leading, spacing: 2.5) {
                Text(notification.title)
                    .pretendard(.body04)
                    .foregroundStyle(Color.gray100)

                Text(notification.content)
                    .pretendard(.caption03)
                    .foregroundStyle(Color.nonOp)

                Text(notification.date)
                    .pretendard(.caption04)
                    .foregroundStyle(Color.nonOp)
            }
            .lineLimit(1)

            Spacer()
        }
        .frame(width: 317, height: 60)
        .padding(.vertical, 9)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray900)
        )
    }
}

#Preview {
    NotificationView(
        store: .init(initialState: NotificationStore.State()) { NotificationStore()
        }
    )
}
