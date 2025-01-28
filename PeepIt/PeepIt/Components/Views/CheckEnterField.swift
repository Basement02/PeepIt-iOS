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

    @FocusState private var isFocused: Bool

    var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading, spacing: 0) {
                Text(store.fieldType.rawValue)
                    .pretendard(.caption01)
                    .padding(.bottom, 20)

                HStack {
                    TextField(
                        store.fieldType.placeholder,
                        text: $store.text
                    )
                    .focused($isFocused)
                    .pretendard(.body02)
                    .tint(
                        store.enterState == .base ?
                        Color.coreLime : Color.white
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
            .onAppear {
                isFocused = true
            }
        }
    }
}

#Preview {
    CheckEnterField(
        store: .init(initialState: CheckEnterFieldStore.State()) { CheckEnterFieldStore() }
    )
}
