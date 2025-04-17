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
            Image("IconClose")
                .resizable()
                .frame(width: 33.6, height: 33.6)
        }
    }
}

#Preview {
    DismissButton {
        print("hi")
    }
}
