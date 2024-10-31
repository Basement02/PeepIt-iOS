//
//  CheckEnterField.swift
//  PeepIt
//
//  Created by 김민 on 10/31/24.
//

import SwiftUI
import ComposableArchitecture

struct CheckEnterField: View {
    @Perception.Bindable var store: StoreOf<CheckEnterFieldStore>

    var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading, spacing: 0) {
                Text(store.content)
                    .pretendard(.caption01)
                    .padding(.bottom, 20)

                HStack {
                    TextField(
                        "\(store.content)를 입력해주세요.",
                        text: $store.text
                    )
                    .pretendard(.body02)
                    .tint(
                        store.enterState == .base ?
                        Color.gray400 : Color.white
                    )
                    .frame(height: 29.4)

                    Spacer()

                    Group {
                        switch store.enterState {
                        case .base:
                            Image("IconOKsign")
                        case .completed:
                            Image("IconOKsignLime")
                        case .error:
                            Image("IconNOsign")
                        }
                    }
                }
                .padding(.bottom, 10)

                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(
                        store.enterState == .base ? Color.white :
                            store.enterState == .completed ? Color.coreLime :
                            Color.coreRed
                    )
                    .padding(.bottom, 10)

                Text(store.message)
                    .pretendard(.caption03)
                    .foregroundStyle(
                        store.enterState == .base ? Color.white :
                            store.enterState == .completed ? Color.coreLime :
                            Color.coreRed
                    )
            }
        }
    }
}

#Preview {
    CheckEnterField(
        store: .init(initialState: CheckEnterFieldStore.State()) { CheckEnterFieldStore() }
    )
}
