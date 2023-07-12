//
//  WeatherRequest.swift
//  SEWeather
//
//  Created by Иван Ровков on 12.07.2023.
//

import Foundation

struct CurrentWeatherRequest: DataRequest {    
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
    
    func decode(_ data: Data) throws -> CurrentWeatherResponse {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        let response = try decoder.decode(CurrentWeatherResponse.self, from: data)
        return response
    }
}

struct CurrentWeatherResponse: Decodable {
    let timezone: String
    let current: CurrentWeatherReport
}

struct CurrentWeatherReport: Decodable {
    let dt: Date
    let sunrise: Date
    let sunset: Date
    let temp: Double
    let humidity: Int
    let uvi: Double
    let feelsLike: Double
    let pressure: Int
    let windSpeed: Double
    let weather: [WeatherType]
    
    struct WeatherType: Decodable {
        let main: String
        let description: String
    }
}

