//
//  View+Extension.swift
//  PeepIt
//
//  Created by 김민 on 11/26/24.
//

import SwiftUI

extension View {

    func endTextEditing() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
