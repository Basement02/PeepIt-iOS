//
//  TownAPIClient.swift
//  PeepIt
//
//  Created by 김민 on 4/8/25.
//

import Foundation
import ComposableArchitecture

struct TownAPIClient {

}

extension TownAPIClient: DependencyKey {

    static let liveValue: TownAPIClient = TownAPIClient(
 
    )
}

extension DependencyValues {

    var townAPIClient: TownAPIClient {
        get { self[TownAPIClient.self] }
        set { self[TownAPIClient.self] = newValue }
    }
}
