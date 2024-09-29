//
//  ModifyGenderView.swift
//  PeepIt
//
//  Created by 김민 on 9/29/24.
//

import SwiftUI
import ComposableArchitecture

struct ModifyGenderView: View {
    @Perception.Bindable var store: StoreOf<ProfileModifyStore>
    
    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                HStack {
                    Text("성별")
                        .font(.system(size: 12))
                    Spacer()
                }
                .padding(.top, 41)
                .padding(.bottom, 30)

                ForEach(GenderType.allCases, id: \.self) { gender in
                    WithPerceptionTracking {
                        GenderCell(
                            title: gender.title,
                            isSelected: gender == store.selectedGender
                        )
                        .onTapGesture {
                            store.send(.selectGender(of: gender))
                        }
                    }
                }

                Spacer()

                modifyButton
                    .padding(.bottom, 17)
            }
            .padding(.horizontal, 20)
        }
    }

    private var modifyButton: some View {
        Button {

        } label: {
            Text("저장")
        }
        .peepItRectangleStyle()
    }
}

fileprivate struct GenderCell: View {
    let title: String
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 9) {
            Circle()
                .frame(width: 20, height: 20)
                .foregroundStyle(Color.init(uiColor: .systemGray4))
                .overlay {
                    if isSelected {
                        Circle()
                            .frame(width: 12, height: 12)
                    }
                }

            Text(title)
                .font(.system(size: 12))
            Spacer()

        }
        .padding(.vertical, 11)
        .contentShape(Rectangle())
    }
}

#Preview {
    NavigationStack {
        ModifyGenderView(
            store: .init(initialState: ProfileModifyStore.State()) { ProfileModifyStore() }
        )
    }
}
