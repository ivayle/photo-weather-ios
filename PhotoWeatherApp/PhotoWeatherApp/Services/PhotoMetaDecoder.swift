//
//  PhotoMetaDecoder.swift
//  PhotoWeatherApp
//
//  Created by Ivaylo Petrov on 20.11.23.
//

import Foundation
import Photos

class PhotoMetaDecoder {
    var geocoder: CLGeocoder?
    
    init(geocoder: CLGeocoder? = nil) {
        self.geocoder = geocoder
    }
    
    func getNearbyCity(fromCoordinates coordinates: CLLocation, completion: @escaping (String?) -> ()) {
        geocoder?.reverseGeocodeLocation(coordinates) { placemarks, error in
            completion(placemarks?.first?.locality)
        }
    }
}
