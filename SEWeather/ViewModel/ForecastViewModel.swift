//
//  ForecastViewModel.swift
//  SEWeather
//
//  Created by Иван Ровков on 12.07.2023.
//

import Foundation

class ForecastViewModel: ObservableObject {
    
    private let networkManager: NetworkManager
    private var locationManager: CoreLocationManager
        
    @Published var networkState: NetworkServiceState = .idle
    @Published var locationState: LocationManagerStatus?
    
    init(networkManager: NetworkManager, locationManager: CoreLocationManager) {
        self.networkManager = networkManager
        self.locationManager = locationManager
        self.locationManager.completion = { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let status):
                self.locationState = status
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    enum NetworkServiceState {
        case idle
        case loading
        case success(ForecastWeather)
        case error(String)
    }
    
    func fetchWeather() {
        self.networkState = .loading
        var request = ForecastWeatherRequest()
        self.locationManager.checkIfLocationServiceIsEnabled()
        
        if case .authorized(let location) = self.locationState {
            guard let coordinate = location?.coordinate else { return }
            request.queryItems["lat"] = "\(coordinate.latitude)"
            request.queryItems["lon"] = "\(coordinate.longitude)"
        }
        
        networkManager.request(request) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.networkState = .success(response)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.networkState = .error(error.localizedDescription)
                }
            }
        }
    }
}
