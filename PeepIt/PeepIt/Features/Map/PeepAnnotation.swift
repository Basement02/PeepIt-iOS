//
//  PeepAnnotation.swift
//  PeepIt
//
//  Created by 김민 on 4/25/25.
//

import Foundation
import MapKit

class PeepAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var peep: Peep

    init(peep: Peep) {
        self.peep = peep
        self.coordinate = CLLocationCoordinate2D(latitude: peep.y, longitude: peep.x)
    }
}
