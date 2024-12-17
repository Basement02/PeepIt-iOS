//
//  LaunchScreen.swift
//  PeepIt
//
//  Created by 김민 on 11/4/24.
//

import SwiftUI

struct LaunchScreen: View {

    @State private var showPeepItCameraOn: Bool = false

    var body: some View {

        Group {
            ZStack(alignment: .top) {
                Color.base
                    .ignoresSafeArea()

                ZStack(alignment: .topLeading) {
                    Image("LogoBase")

                    if showPeepItCameraOn {
                        Image("PeepItCameraOn")
                            .transition(.opacity)
                            .animation(
                                .easeIn(duration: 0.5),
                                value: showPeepItCameraOn
                            )
                    }
                }
                .padding(.top, 184.adjustedH)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    showPeepItCameraOn = true
                }
            }
        }
    }
}

#Preview {
    LaunchScreen()
}
