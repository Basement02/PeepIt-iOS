//
//  BackButton.swift
//  PeepIt
//
//  Created by 김민 on 11/22/24.
//

import SwiftUI

struct BackButton: View {
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
            PressableButtonStyle(
                originImg: "BackN",
                pressedImg: "BackY"
            )
        )
    }
}

#Preview {
    BackButton {
        print("hi")
    }
}
