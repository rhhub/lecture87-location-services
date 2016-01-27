//
//  BootcampAnnotation.swift
//  lecture87-location-services
//
//  Created by Ryan Huebert on 1/27/16.
//  Copyright © 2016 Ryan Huebert. All rights reserved.
//

import Foundation
import MapKit

class BootcampAnnotation: NSObject, MKAnnotation {
    var coordinate = CLLocationCoordinate2D()
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
