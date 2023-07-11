//
//  ForecastWeatherRequest.swift
//  SEWeather
//
//  Created by Иван Ровков on 12.07.2023.
//

import Foundation

struct ForecastWeatherRequest: DataRequest {
    private let apiKey: String = "052498d28e3fd8ab933bfb1b9b183e90"
    
    var url: String {
        let baseURL: String = "https://api.openweathermap.org"
        let path: String = "/data/3.0/onecall"
        return baseURL + path
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var queryItems: [String : String] {
        return [
            "lat": "55.33",
            "lon": "86.08",
            "exclude": "hourly",
            "lang": "ru",
            "appid": apiKey
        ]
    }
    
    func decode(_ data: Data) throws -> ForecastWeatherResponse {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        let response = try decoder.decode(ForecastWeatherResponse.self, from: data)
        return response
    }
}

struct ForecastWeatherResponse: Decodable {
    let timezone: String
    let current: CurrentWeatherReport
    let daily: [DailyWeatherReport]
}

struct DailyWeatherReport: Decodable {
    let dt: Date
    let sunrise: Date
    let sunset: Date
    let temp: TemperatureInfo
    let feelsLike: FeelsLikeInfo
    let pressure: Int
    let windSpeed: Double
    let weather: [WeatherType]
    
    struct WeatherType: Decodable {
        let main: String
        let description: String
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

