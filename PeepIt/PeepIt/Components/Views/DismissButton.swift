//
//  DismissButton.swift
//  PeepIt
//
//  Created by 김민 on 11/22/24.
//

import SwiftUI

struct DismissButton: View {
    let action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            Rectangle()
                .fill(Color.clear)
                .frame(width: 33.6, height: 33.6)
        }
        .buttonStyle(
            PressableButtonStyle(originImg: "CloseN", pressedImg: "CloseY")
        )
    }
}

#Preview {
    DismissButton {
        print("hi")
    }
}
