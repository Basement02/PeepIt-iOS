//
//  CommentedPeepCell.swift
//  PeepIt
//
//  Created by 김민 on 9/23/24.
//

import SwiftUI

struct CommentedPeepCell: View {
    let peep: CommentedPeep

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color.init(uiColor: .lightGray))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            peep.isActivate ? Color.black : Color.clear,
                            lineWidth: 3
                        )
                )

            VStack {
                Spacer()

                HStack {
                    Text("\(peep.distance)km")
                        .font(.system(size: 12))
                    Spacer()
                }
                .padding(.leading, 13)
                .padding(.bottom, 9)
            }
        }
    }
}

#Preview {
    CommentedPeepCell(peep: .commentPeepStub)
}
