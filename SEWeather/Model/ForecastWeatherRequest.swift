//
//  ForecastWeatherRequest.swift
//  SEWeather
//
//  Created by Иван Ровков on 12.07.2023.
//

import Foundation

struct ForecastWeatherRequest: DataRequest {    
    var url: String {
        let baseURL: String = "https://api.openweathermap.org"
        let path: String = "/data/3.0/onecall"
        return baseURL + path
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var queryItems: [String : String] =  [
        "units": "metric",
        "exclude": "hourly",
        "appid": Config.apikey
    ]
    
    func decode(_ data: Data) throws -> ForecastWeather {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        let response = try decoder.decode(ForecastWeather.self, from: data)
        return response
    }
}

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
