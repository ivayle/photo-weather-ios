//
//  PhotoWeatherInfo.swift
//  PhotoWeatherApp
//
//  Created by Ivaylo Petrov on 21.11.23.
//

import Foundation

// MARK: - ImageLocation
struct PhotoWeatherMeta: Decodable {
    let timezone: String
    let data: [WeatherInfo]

    enum CodingKeys: String, CodingKey {
        case timezone
        case data
    }
}
