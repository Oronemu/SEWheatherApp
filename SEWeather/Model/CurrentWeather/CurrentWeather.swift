//
//  CurrentWeather.swift
//  SEWeather
//
//  Created by Иван Ровков on 13.07.2023.
//

import Foundation

struct CurrentWeather: Decodable {
    let dt: Date
    let name: String
    let timezone: Int
    let weather: [Weather]
    let main: Main
    let sys: Sys
    let wind: Wind

    struct Main: Decodable {
        let temp: Double
        let feelsLike: Double
        let tempMin: Double
        let tempMax: Double
        let pressure: Int
        let humidity: Int
    }

    struct Weather: Decodable {
        let main: String
        let weatherDescription: String
        let icon: String
        
        private enum CodingKeys: String, CodingKey {
            case main
            case weatherDescription = "description"
            case icon
        }
    }
    
    struct Sys: Decodable {
        let country: String
        let sunrinse: Date?
        let sunset: Date?
    }
    
    struct Wind: Decodable {
        let speed: Double
    }
}
