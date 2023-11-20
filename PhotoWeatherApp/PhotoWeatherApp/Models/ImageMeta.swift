//
//  ImageMeta.swift
//  PhotoWeatherApp
//
//  Created by Ivaylo Petrov on 20.11.23.
//

import Foundation
import Photos

struct ImageMeta {
    var date: Date?
    var coordinates: CLLocation?
    
    init(date: Date?, coordinates: CLLocation?) {
        self.date = date
        self.coordinates = coordinates
    }
}
