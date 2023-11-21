//
//  ImageMeta.swift
//  PhotoWeatherApp
//
//  Created by Ivaylo Petrov on 20.11.23.
//

import Foundation
import Photos

struct PhotoMeta {
    var date: Date?
    var location: CLLocation?
    
    init(date: Date?, location: CLLocation?) {
        self.date = date
        self.location = location
    }
}
