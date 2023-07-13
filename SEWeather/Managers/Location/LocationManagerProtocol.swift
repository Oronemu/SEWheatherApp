//
//  LocationServiceProtocol.swift
//  SEWeather
//
//  Created by Иван Ровков on 12.07.2023.
//

import CoreLocation

protocol LocationManager {
    var completion: ((Result<LocationManagerStatus, Error>) -> Void)? { get set }
    func checkIfLocationServiceIsEnabled()
}
