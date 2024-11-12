//
//  NavigationBar.swift
//  PeepIt
//
//  Created by 김민 on 10/30/24.
//

import SwiftUI

struct NavigationBar<Button: View>: View {
    let leadingButton: Button?
    let title: String?
    let trailingButton: Button?

    init(
        leadingButton: Button? = nil,
        title: String? = nil,
        trailingButton: Button? = nil
    ) {
        self.leadingButton = leadingButton
        self.title = title
        self.trailingButton = trailingButton
    }

    var body: some View {
        HStack {
            if let leadingButton = leadingButton {
                leadingButton
            }

            Spacer()

            if let title = title {
                Text(title)
                    .pretendard(.subhead)
            }

            Spacer()

            if let trailingButton = trailingButton {
                trailingButton
            }
        }
        .padding(.horizontal, 16.adjustedW)
        .frame(maxWidth: .infinity)
        .frame(height: 44)
        .background(Color.base)
    }
}
