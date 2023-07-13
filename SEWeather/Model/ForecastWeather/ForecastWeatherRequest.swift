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
