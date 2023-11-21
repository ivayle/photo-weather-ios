//
//  PhotoWeatherInfo.swift
//  PhotoWeatherApp
//
//  Created by Ivaylo Petrov on 21.11.23.
//

import Foundation

// MARK: - Info
struct PhotoWeatherInfo: Decodable {
    let temp, feelsLike: Double
    let weather: [PhotoWeather]

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case weather
    }
}
