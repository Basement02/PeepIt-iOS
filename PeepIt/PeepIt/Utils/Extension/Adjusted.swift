//
//  Adjusted.swift
//  PeepIt
//
//  Created by 김민 on 10/28/24.
//

import Foundation

extension CGFloat {

    var adjustedW: CGFloat {
        let ratio: CGFloat = Constant.screenWidth / 393
        return self * ratio
    }

    var adjustedH: CGFloat {
        let ratio: CGFloat = Constant.screenHeight / 852
        return self * ratio
    }
}

extension Double {

    var adjustedW: Double {
        let ratio: Double = Double(Constant.screenWidth / 393)
        return self * ratio
    }

    var adjustedH: Double {
        let ratio: Double = Double(Constant.screenHeight / 852)
        return self * ratio
    }
}

extension Int {

    var adjustedW: Double {
        let ratio: Double = Double(Constant.screenWidth / 393)
        return Double(self) * ratio
    }

    var adjustedH: Double {
        let ratio: Double = Double(Constant.screenHeight / 852)
        return Double(self) * ratio
    }
}
