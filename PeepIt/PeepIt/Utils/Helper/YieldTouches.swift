//
//  YieldTouches.swift
//  PeepIt
//
//  Created by 김민 on 1/17/25.
//

import SwiftUI

extension View {
    
    func yieldTouches() -> some View { modifier(YieldTouches()) }
}

/// 제스처 conflict 해결
struct YieldTouches: ViewModifier {
    @State private var disabled = false

    func body(content: Content) -> some View {
        content
            .disabled(disabled) // disabled 상태에 따라 뷰의 터치 이벤트 처리 여부를 제어
            .onTapGesture {
                onMain { disabled = true; onMain { disabled = false } }
            }
    }

    private func onMain(_ action: @escaping () -> Void) {
        DispatchQueue.main.async(execute: action) // 메인 스레드에서 비동기로 실행
    }
}
