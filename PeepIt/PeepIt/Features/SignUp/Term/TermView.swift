//
//  TermView.swift
//  PeepIt
//
//  Created by 김민 on 10/1/24.
//

import SwiftUI
import ComposableArchitecture

struct TermView: View {
    let store: StoreOf<TermStore>

    var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading, spacing: 0) {

                Text("원활한 서비스 이용을 위해\n아래 약관에 동의해 주세요.")
                    .font(.system(size: 18))
                    .padding(.top, 60)

                allAgreeButtton
                    .padding(.top, 10)

                ForEach(TermType.allCases, id: \.self) { term in
                    WithPerceptionTracking {
                        termLabel(term: term, isAgreed: store[term])
                            .padding(.vertical, 15)
                            .onTapGesture {
                                store.send(.termToggled(term))
                            }
                    }
                }

                Spacer()

                Button {
                    store.send(.nextButtonTapped)
                } label: {
                    Text("다음")
                }
                .peepItRectangleStyle(
                    backgroundColor: store.isNextButtonActivated ? .black : .gray
                )
                .disabled(!store.isNextButtonActivated)
                .padding(.bottom, 17)
            }
            .padding(.horizontal, 23)
        }
    }

    private var allAgreeButtton: some View {
        Button {
            store.send(.allAgreeButtonTapped)
        } label: {
            HStack {
                Text("아래 약관에 모두 동의합니다.")
                Spacer()
                Image(systemName: "checkmark.circle.fill")
            }
            .padding(.vertical, 20)
        }
        .contentShape(Rectangle())
    }
}

fileprivate struct termLabel: View {
    let term: TermType
    var isAgreed: Bool

    var body: some View {
        HStack {
            Image(systemName: "checkmark")
        
            Group {
                Text(term.isEssential ? "[필수]" : "[선택]") + Text(" \(term.title)")
            }
            .underline()
        }
        .contentShape(Rectangle())
        .foregroundStyle(isAgreed ? .red : .gray)
    }
}

#Preview {
    TermView(
        store: .init(initialState: TermStore.State()) { TermStore() }
    )
}
