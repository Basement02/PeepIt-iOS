//
//  ProfileInfoView.swift
//  PeepIt
//
//  Created by 김민 on 10/7/24.
//

import SwiftUI
import ComposableArchitecture

struct ProfileInfoView: View {
    @Perception.Bindable var store: StoreOf<ProfileInfoStore>

    var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading, spacing: 0) {
                Text("_ 님에 대해\n좀 더 알려주세요.")
                    .font(.system(size: 18))
                    .padding(.top, 48)
                    .padding(.bottom, 54)

                TextField("YYYY.MM.DD", text: $store.date)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .padding(.bottom, 10)

                Text("생년월일을 선택해 주세요. (선택)")
                    .font(.system(size: 12, weight: .regular))
                    .padding(.bottom, 24)

                HStack(spacing: 15) {
                    ForEach(GenderType.allCases, id: \.self) { gender in
                        GenderButton(
                            gender: gender,
                            isSelected: gender == store.selectedGender
                        )
                        .onTapGesture {
                            store.send(.selectedGender(gender))
                        }
                    }
                }
                .frame(height: 38)
                .padding(.bottom, 10)

                Text("성별을 선택해 주세요. (선택)")
                    .font(.system(size: 12, weight: .regular))

                Spacer()

                Button {
                    store.send(.nextButtonTapped)
                } label: {
                    Text("다음")
                }
            }
            .padding(.horizontal, 23)
        }
    }

    private var backButton: some View {
        Button {
            store.send(.backButtonTapped)
        } label: {
            Image("backN")
        }
    }
}

fileprivate struct GenderButton: View {
    let gender: GenderType
    var isSelected: Bool

    var body: some View {
        ZStack {
            if isSelected {
                Color.green
            } else {
                Color.init(uiColor: .systemGray4)
            }

            Text(gender.minTitle)
        }
    }
}

#Preview {
    ProfileInfoView(
        store: .init(initialState: ProfileInfoStore.State()) { ProfileInfoStore() }
    )
}
