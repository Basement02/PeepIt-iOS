//
//  MapInteractionState.swift
//  PeepIt
//
//  Created by 김민 on 4/15/25.
//

enum MapInteractionState: Equatable {
    case idle          // 초기 상태
    case moved         // 사용자가 지도 드래그함
    case resetRequested // 현재 위치로 돌아가기 요청
}
