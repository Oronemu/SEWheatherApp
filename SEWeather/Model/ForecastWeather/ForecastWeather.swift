//
//  ForecastWeather.swift
//  SEWeather
//
//  Created by Иван Ровков on 13.07.2023.
//

import Foundation

struct ForecastWeather: Decodable {
    let daily: [DailyWeatherReport]
    let alerts: [WeatherAlert]?
    
    struct WeatherAlert: Decodable {
        let senderName: String
        let event: String
        let description: String
    }
    
    struct DailyWeatherReport: Decodable {
        let dt: Date
        let sunrise: Date
        let sunset: Date
        let summary: String
        let temp: TemperatureInfo
        let feelsLike: FeelsLikeInfo
        let pressure: Int
        let windSpeed: Double
        let weather: [WeatherType]
        
        struct WeatherType: Decodable {
            let main: String
            let description: String
            let icon: String
        }
        
        struct TemperatureInfo: Decodable {
            let day: Double
            let min: Double
            let max: Double
            let night: Double
            let eve: Double
            let morn: Double
        }
        
        struct FeelsLikeInfo: Decodable {
            let day: Double
            let night: Double
            let eve: Double
            let morn: Double
        }
    }
}
