//
//  Weather.swift
//  PhotoWeatherApp
//
//  Created by Ivaylo Petrov on 21.11.23.
//

import Foundation

// MARK: - Weather
struct Weather: Decodable {
    let main, description: String
}
