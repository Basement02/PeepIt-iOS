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

    @FocusState private var isFocused: Bool

    var body: some View {
        WithPerceptionTracking {
            GeometryReader { _ in
                WithPerceptionTracking {
                    ZStack {
                        Color.base
                            .ignoresSafeArea()

                        VStack(spacing: 0) {
                            PeepItNavigationBar(leading: backButton)
                                .padding(.bottom, 23)

                            VStack(spacing: 50) {
                                titleView

                                birthField

                                genderListView
                            }
                            .padding(.leading, 20)

                            Spacer()

                            if store.isBirthValidate {
                                nextButton
                                    .padding(.bottom, 84)
                            }
                        }
                        .ignoresSafeArea(.all, edges: .bottom)
                    }
                    .background(Color.base)
                    .toolbar(.hidden, for: .navigationBar)
                    .onAppear { isFocused = true }
                    .onTapGesture { endTextEditing() }
                    .onChange(of: isFocused) { _ in
                        if !isFocused {
                            store.send(.tfFocusing)
                        } else {
                            store.send(.tfNotFocusing)
                        }
                    }
                    .onChange(of: store.endEdit) { newValue in
                        if newValue { isFocused = false }
                    }
                }
            }
        }
    }

    private var backButton: some View {
        BackButton { store.send(.backButtonTapped) }
    }

    private var titleView: some View {
        HStack {
            Text("닉네임님에 대해\n좀 더 알려주세요.")
                .pretendard(.title02)
            Spacer()
        }
    }

    private var nextButton: some View {
        Button {
            store.send(.nextButtonTapped)
        } label: {
            Text("다음")
                .mainButtonStyle()
                .foregroundStyle(Color.white)
        }
        .buttonStyle(PressableButtonStyle(colorStyle: .gray900))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var birthField: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 7) {
                    Text("생년월일")
                        .pretendard(.caption01)
                    Text("(선택사항)")
                        .pretendard(.caption03)
                        .foregroundStyle(Color.gray300)

                    Spacer()
                }
                .padding(.bottom, 10)

                TextField("YYYY.MM.DD", text: $store.date)
                    .focused($isFocused)
                    .pretendard(.body02)
                    .tint(Color.coreLime)
                    .frame(height: 29.4)
                    .keyboardType(.numberPad)

                Rectangle()
                    .fill(store.isBirthValidate ? Color.white : Color.coreRed)
                    .frame(height: 1)

                Text(store.guideline.isEmpty ? " " : store.guideline)
                    .pretendard(.caption03)
                    .foregroundStyle(store.isBirthValidate ? Color.white : Color.coreRed)
            }
            .frame(width: 285)

            Spacer()
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
                        store.send(.selectedGender(item))
                    }
                }
            }
            .padding(.trailing, 17)
        }
    }
}

#Preview {
    ProfileInfoView(
        store: .init(initialState: ProfileInfoStore.State()) { ProfileInfoStore() }
    )
}
