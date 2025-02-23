//
//  PressableButtonStyle.swift
//  PeepIt
//
//  Created by 김민 on 11/18/24.
//

import SwiftUI

//struct PressableButtonStyle: ButtonStyle {
//    let originImg: String
//    let pressedImg: String
//
//    func makeBody(configuration: Configuration) -> some View {
//        configuration.label
//            .overlay {
//                Image(configuration.isPressed ? pressedImg : originImg)
//            }
//    }
//}

struct PressableViewButtonStyle<NormalView: View, PressedView: View>: ButtonStyle {
    let normalView: NormalView
    let pressedView: PressedView

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            if configuration.isPressed {
                pressedView
            } else {
                normalView
            }

            configuration.label
        }
    }
}
