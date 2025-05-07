//
//  PopUpAView.swift
//  PeepIt
//
//  Created by 김민 on 5/7/25.
//

import SwiftUI

enum PopUpType: String {
    case logout = "로그아웃"

    var description: String {
        switch self {
        case .logout:
            return "로그아웃 하시겠습니까?"
        }
    }

    var btnName: String {
        switch self {
        case .logout:
            return "로그아웃"
        }
    }
}

struct PopUpAView: View {
    let popUpType: PopUpType
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.gray900)

            VStack(spacing: 11) {
                HStack {
                    VStack(alignment: .leading, spacing: 11) {
                        Text(popUpType.rawValue)
                            .pretendard(.title03)

                        Text(popUpType.description.forceCharWrapping)
                            .pretendard(.body03)
                            .frame(height: 71, alignment: .topLeading)
                    }

                    Spacer()
                }
                .padding(.horizontal, 5)
                .frame(width: 294, height: 110)

                HStack {
                    Button {
                        onCancel()
                    } label: {
                        Text("취소")
                            .pretendard(.headline)
                            .foregroundStyle(Color.white)
                            .frame(width: 143, height: 50)
                            .background(Color.gray700)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    Button {
                        onConfirm()
                    } label: {
                        Text(popUpType.btnName)
                            .pretendard(.headline)
                            .foregroundStyle(Color.gray700)
                            .frame(width: 143, height: 50)
                            .background(Color.coreLime)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
        }
        .frame(width: 329, height: 222)
    }
}

#Preview {
    PopUpAView(popUpType: .logout, onConfirm: { }, onCancel: { })
}
