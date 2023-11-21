//
//  PhotoWeatherResult.swift
//  PhotoWeatherApp
//
//  Created by Ivaylo Petrov on 21.11.23.
//

import Foundation

struct PhotoWeatherResult {
    let place: String
    let temperature: Int
    let description: String
    
    init(place: String, temperature: Int, description: String) {
        self.place = place
        self.temperature = temperature
        self.description = description
    }
}
