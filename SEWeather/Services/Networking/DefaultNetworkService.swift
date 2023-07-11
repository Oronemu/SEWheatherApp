//
//  DefaultNetworkService.swift
//  SEWeather
//
//  Created by Иван Ровков on 12.07.2023.
//

import Foundation

class DefaultNetworkService: NetworkService {
    
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        return URLSession(configuration: config)
    }()
    
    func request<Request>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) where Request : DataRequest {
        
        guard var urlComponent = URLComponents(string: request.url) else {
            let error = NSError(domain: "InvalidEndpoint", code: 404)
            
            return completion(.failure(error))
        }
        
        var queryItems: [URLQueryItem] = []
        
        request.queryItems.forEach { key, value in
            let urlQueryItem = URLQueryItem(name: key, value: value)
            urlComponent.queryItems?.append(urlQueryItem)
            queryItems.append(urlQueryItem)
        }
        
        urlComponent.queryItems = queryItems
        
        guard let url = urlComponent.url else {
            let error = NSError(domain: "InvalidEndpoint", code: 404)
            
            return completion(.failure(error))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        
        session.dataTask(with: urlRequest) { data, response, error in
            if let error {
                return completion(.failure(error))
            }
            
            guard let response = response else {
                return completion(.failure(NSError()))
            }
            
            guard let data = data else {
                return completion(.failure(NSError()))
            }
            
            do {
                try completion(.success(request.decode(data)))
            } catch let error as NSError {
                completion(.failure(error))
            }
        }.resume()
    }
}
