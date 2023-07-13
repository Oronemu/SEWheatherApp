//
//  NetworkServiceProtocol.swift
//  SEWeather
//
//  Created by Иван Ровков on 12.07.2023.
//

import Foundation

protocol NetworkManager {
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void)
}

