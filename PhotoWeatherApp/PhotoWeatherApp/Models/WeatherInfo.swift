//
//  WeatherInfo.swift
//  PhotoWeatherApp
//
//  Created by Ivaylo Petrov on 21.11.23.
//

import Foundation

// MARK: - Info
struct WeatherInfo: Decodable {
    let temp, feelsLike: Double
    let weather: [Weather]

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case weather
    }
}
