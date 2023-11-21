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
    let main: PhotoWeatherType?
    let description: String
    
    init(place: String, temperature: Int, main: String, description: String) {
        self.place = place
        self.temperature = temperature
        self.main = PhotoWeatherType(rawValue: main)
        self.description = description
    }
}

enum PhotoWeatherType: String {
    case thunderstorm = "Thunderstorm"
    case drizzle = "Drizzle"
    case rain = "Rain"
    case snow = "Snow"
    case atmoshphere = "Atmosphere"
    case clear = "Clear"
    case clouds = "Clouds"
}
