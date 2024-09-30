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
        VStack {
            Spacer()

            Text("약관 뷰")
            
            Spacer()

            Button {
                store.send(.nextButtonTapped)
            } label: {
                Text("다음")
            }
            .peepItRectangleStyle()
            .padding(.bottom, 17)
        }
    }
}

#Preview {
    TermView(
        store: .init(initialState: TermStore.State()) { TermStore() }
    )
}
