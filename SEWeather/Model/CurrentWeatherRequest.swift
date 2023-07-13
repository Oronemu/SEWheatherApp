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
        let path: String = "/data/2.5/weather"
        return baseURL + path
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var queryItems: [String : String] =  [
        "units": "metric",
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
    let dt: Date
    let name: String
    let timezone: Int
    let weather: [Weather]
    let main: Main
    let sys: Sys
    let wind: Wind

    struct Main: Decodable {
        let temp: Double
        let tempMin: Double
        let tempMax: Double
        let pressure: Int
        let humidity: Int
    }

    struct Weather: Decodable {
        let main: String
        let description: String
        let icon: String
    }
    
    struct Sys: Decodable {
        let country: String
    }
    
    struct Wind: Decodable {
        let speed: Double
    }
}

