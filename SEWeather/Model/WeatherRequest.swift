//
//  WeatherRequest.swift
//  SEWeather
//
//  Created by Иван Ровков on 12.07.2023.
//

import Foundation

struct WeatherRequest: DataRequest {
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
            "lat": "33.44",
            "lon": "-94.04",
            "appid": apiKey
        ]
    }
    
    func decode(_ data: Data) throws -> WeatherResponse {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        let response = try decoder.decode(WeatherResponse.self, from: data)
        return response
    }
}

struct WeatherResponse: Decodable {
    let timezone: String
    let current: WeatherReport
//    let daily: [WeatherReport]
}

struct WeatherReport: Decodable {
    let dt: Date
    let sunrise: Date
    let sunset: Date
    let temp: Double
    let feelsLike: Double
    let pressure: Int
    let windSpeed: Double
    let weather: [WeatherType]
    
    struct WeatherType: Decodable {
        let main: String
        let description: String
    }
}

