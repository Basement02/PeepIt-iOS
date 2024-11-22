//
//  PeepItNavigationBar.swift
//  PeepIt
//
//  Created by 김민 on 11/22/24.
//

import SwiftUI

struct PeepItNavigationBar<Leading: View, Trailing: View>: View {
    var leading: Leading
    var title: String?
    var trailing: Trailing

    init(
        leading: Leading = EmptyView(),
        title: String? = nil,
        trailing: Trailing = EmptyView()
    ) {
        self.leading = leading
        self.title = title
        self.trailing = trailing
    }

    var body: some View {
        ZStack {
            Color.base

            HStack(spacing: 0) {
                leading

                Spacer()

                trailing
            }
            .padding(.horizontal, 16)

            if let title = title {
                Text(title)
                    .pretendard(.subhead)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 44)
    }
}

#Preview {
    VStack {
        PeepItNavigationBar(
            leading: Text("Back"),
            title: "hello",
            trailing: Text("Else")
        )

        PeepItNavigationBar(leading: Text("Back"))

        PeepItNavigationBar(title: "hello")
    }
}
