//
//  DataRequestProtocol.swift
//  SEWeather
//
//  Created by Иван Ровков on 12.07.2023.
//

import Foundation

protocol DataRequest {
    associatedtype Response
    
    var url: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryItems: [String: String] { get set }
    
    func decode(_ data: Data) throws -> Response
}

extension DataRequest where Response: Decodable {
    func decode(_ data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}

extension DataRequest {
    var headers: [String: String] {
        return [:]
    }
    
    var queryItems: [String: String] {
        return [:]
    }
}
