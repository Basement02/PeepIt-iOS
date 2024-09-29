//
//  ReactedPeepCell.swift
//  PeepIt
//
//  Created by 김민 on 9/23/24.
//

import SwiftUI

struct ReactedPeepCell: View {
    let peep: ReactedPeep

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color.init(uiColor: .lightGray))

            VStack {
                HStack {
                    Spacer()

                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 25, height: 25)
                }

                Spacer()

                HStack {
                    Text("\(peep.distance)km")
                        .font(.system(size: 12))
                    Spacer()
                }
            }
            .padding(.all, 10)
        }
    }
}

#Preview {
    ReactedPeepCell(peep: .reactPeepStub)
}
