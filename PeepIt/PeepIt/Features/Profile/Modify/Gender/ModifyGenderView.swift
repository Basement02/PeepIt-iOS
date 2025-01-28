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

                PeepItNavigationBar(
                    leading: BackButton { store.send(.backButtonTapped) }
                )
                .padding(.bottom, 23)

                VStack(alignment: .leading, spacing: 50) {
                    HStack {
                        Text("성별을 선택해주세요.")
                            .pretendard(.title02)
                    }

                    genderListView

                    Spacer()
                }
                .padding(.leading, 20)

                saveButton
                    .padding(.bottom, 84)
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .background(Color.base)
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var genderListView: some View {
        VStack(spacing: 20) {
            HStack(spacing: 7) {
                Text("성별")
                    .pretendard(.caption01)
                Text("(선택사항)")
                    .pretendard(.caption03)
                    .foregroundStyle(Color.gray300)

                Spacer()
            }

            HStack(spacing: 9) {
                ForEach(
                    Array(zip(GenderType.allCases.indices,
                              GenderType.allCases)
                    ), id: \.0
                ) { idx, item in
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(
                                store.selectedGender == item ? Color.coreLime : Color.white,
                                lineWidth: 1
                            )

                        Text(item.title)
                            .pretendard(.caption01)
                    }
                    .foregroundStyle(
                        store.selectedGender == item ? Color.coreLime : Color.white
                    )
                    .frame(height: 40)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        store.send(.selectGender(item))
                    }
                }
            }
            .padding(.trailing, 17)
        }
    }

    private var saveButton: some View {
        Button {
            store.send(.saveButtonTapped)
        } label: {
            Text("저장")
                .mainGrayButtonStyle()
        }
    }
}

#Preview {
    ModifyGenderView(
        store: .init(initialState: ProfileModifyStore.State()) {
            ProfileModifyStore()
        }
    )
}
