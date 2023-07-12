//
//  CoreLocationService.swift
//  SEWeather
//
//  Created by Иван Ровков on 12.07.2023.
//

import CoreLocation
import Dispatch

enum LocationServiceStatus {
    case authorized(CLLocation?)
    case notDetermined
    case restricted
    case denied
    case disabled
}

class CoreLocationService: NSObject, LocationService {
    
    private var locationManager = CLLocationManager()
    private var location: CLLocationCoordinate2D?
    var completion: ((Result<LocationServiceStatus, Error>) -> Void)?
    
    func checkIfLocationServiceIsEnabled() {
        // TODO: Вынести это в отдельную очередь
        if CLLocationManager.locationServicesEnabled() {
            superclass?.initialize()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            checkLocationAuthorization()
        } else {
            self.completion?(.success(.disabled))
        }
    }
    
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            completion?(.success(.notDetermined))
        case .restricted:
            completion?(.success(.restricted))
        case .denied:
            completion?(.success(.denied))
        case .authorizedAlways, .authorizedWhenInUse:
            completion?(.success(.authorized(locationManager.location)))
        @unknown default:
            completion?(.failure(NSError()))
        }
    }
}

extension CoreLocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {        
        self.location = locations.first?.coordinate
    }
}
