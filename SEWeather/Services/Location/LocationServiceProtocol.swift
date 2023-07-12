//
//  LocationServiceProtocol.swift
//  SEWeather
//
//  Created by Иван Ровков on 12.07.2023.
//

import CoreLocation

protocol LocationService {
    var completion: ((Result<LocationServiceStatus, Error>) -> Void)? { get set }
    func checkIfLocationServiceIsEnabled()
}
