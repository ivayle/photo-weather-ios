//
//  PhotoMeta.swift
//  PhotoWeatherApp
//
//  Created by Ivaylo Petrov on 20.11.23.
//

import Foundation
import Photos

// MARK: - PhotoMeta
struct PhotoMeta {
    var date: Date
    var location: CLLocation?
    var longitude: CLLocationDegrees
    var latitude: CLLocationDegrees
    
    init(date: Date, location: CLLocation) {
        self.date = date
        self.location = location
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
    }
}
