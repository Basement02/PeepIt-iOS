//
//  TermView.swift
//  PeepIt
//
//  Created by 김민 on 10/1/24.
//

import SwiftUI
import ComposableArchitecture

struct TermView: View {
    @Perception.Bindable var store: StoreOf<TermStore>

    var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading, spacing: 0) {

                PeepItNavigationBar(leading: backButton)
                    .padding(.bottom, 23)

                Group {
                    title
                        .padding(.bottom, 50)

                    allAgreeButtton
                        .padding(.bottom, 50)

                    termList

                    Spacer()

                    if store.isNextButtonActivated {
                        nextButton
                            .padding(.bottom, 84)
                    }
                }
                .padding(.leading, 20)
            }
            .padding(.trailing, 15.6)
            .background(Color.base)
            .ignoresSafeArea(.all, edges: .bottom)
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var backButton: some View {
        BackButton {
            store.send(.backButtonTapped)
        }
    }

    private var title: some View {
        Text("원활한 서비스 이용을 위해\n아래 약관에 동의해주세요.")
            .pretendard(.title02)
    }

    private var allAgreeButtton: some View {
        Button {
            store.send(.allAgreeButtonTapped)
        } label: {
            HStack {
                Text("아래 약관에 모두 동의합니다.")
                    .pretendard(.headline)
                    .foregroundStyle(Color.white)

                Spacer()

                Image(
                    store.isAllAgreed ?
                    "IconOKsignLime" : "IconOKsign"
                )
            }
        }
        .contentShape(Rectangle())
    }

    private var termList: some View {
        VStack(alignment: .leading, spacing: 22) {
            ForEach(TermType.allCases, id: \.self) { term in
                WithPerceptionTracking {
                    termLabel(term: term, isAgreed: store[term])
                        .onTapGesture {
                            store.send(.termToggled(term))
                        }
                }
            }
        }
    }

    private var nextButton: some View {
        HStack {
            Spacer()

            NavigationLink(
                state: RootStore.Path.State.inputId(InputIdStore.State())
            ) {
                Text("다음")
                    .mainGrayButtonStyle()
            }

            Spacer()
        }
    }
}

fileprivate struct termLabel: View {
    let term: TermType
    var isAgreed: Bool

    var body: some View {
        HStack {
            Image(isAgreed ? "CheckY" : "CheckN")

            Group {
                Text(term.isEssential ? "(필수)" : "(선택)")
                + Text(" \(term.title)")
            }
            .pretendard(.caption03)
            .underline()

            Spacer()
        }
        .foregroundStyle(.white)
        .contentShape(Rectangle())
    }
}

#Preview {
    TermView(
        store: .init(initialState: TermStore.State()) { TermStore() }
    )
}
