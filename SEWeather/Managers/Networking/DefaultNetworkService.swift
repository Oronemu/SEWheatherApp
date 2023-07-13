//
//  DefaultNetworkService.swift
//  SEWeather
//
//  Created by Иван Ровков on 12.07.2023.
//

import Foundation

class DefaultNetworkManager: NetworkManager {
    
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        return URLSession(configuration: config)
    }()
    
    func request<Request>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) where Request : DataRequest {
        
        guard var urlComponent = URLComponents(string: request.url) else {
            let error = NSError(domain: "InvalidEndpoint", code: 404)
            completion(.failure(error))
            return
        }
        
        var queryItems: [URLQueryItem] = []
        
        for (key, value) in request.queryItems {
            let urlQueryItem = URLQueryItem(name: key, value: value)
            urlComponent.queryItems?.append(urlQueryItem)
            queryItems.append(urlQueryItem)
        }
        
        urlComponent.queryItems = queryItems
        
        guard let url = urlComponent.url else {
            let error = NSError(domain: "InvalidEndpoint", code: 404)
            completion(.failure(error))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        
        session.dataTask(with: urlRequest) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard response != nil else {
                let error = NSError(domain: "InvalidResponse", code: 400)
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "InvalidData", code: 400)
               completion(.failure(error))
                return
            }
            
            do {
                let decodedResponse = try request.decode(data)
                completion(.success(decodedResponse))
            } catch let error as NSError {
                completion(.failure(error))
            }
        }.resume()
    }
}
