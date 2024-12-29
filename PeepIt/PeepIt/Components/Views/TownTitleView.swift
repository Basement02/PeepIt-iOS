//
//  TownTitleView.swift
//  PeepIt
//
//  Created by 김민 on 12/29/24.
//

import SwiftUI

struct TownTitleView: View {
    let townName: String

    var body: some View {
        HStack(spacing: 2){
            Image("IconLocation")
                .resizable()
                .frame(width: 22.4, height: 22.4)
            Text(townName)
                .pretendard(.body02)
        }
        .padding(.vertical, 9)
        .padding(.leading, 15)
        .padding(.trailing, 23)
    }
}

#Preview {
    TownTitleView(townName: "남천동")
}
