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
    
    func decode(_ data: Data) throws -> CurrentWeather {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        let response = try decoder.decode(CurrentWeather.self, from: data)
        return response
    }
}
