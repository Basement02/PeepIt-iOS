//
//  LaunchScreen.swift
//  PeepIt
//
//  Created by 김민 on 11/4/24.
//

import SwiftUI

struct LaunchScreen: View {

    @State private var isShowingFirstImage: Bool = true

    var body: some View {

        Group {
            if isShowingFirstImage {
                Image("splash01")
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isShowingFirstImage = false
                            }
                        }
                    }
            } else {
                Image("splash02")
            }
        }
        .ignoresSafeArea()
        .background(Color.base)
    }
}

#Preview {
    LaunchScreen()
}
