//
//  ForecastViewModel.swift
//  SEWeather
//
//  Created by Иван Ровков on 12.07.2023.
//

import Foundation

class ForecastViewModel: ObservableObject {
    
    private let networkService: NetworkService
    private var locationService: CoreLocationService
    
    @Published var networkState: NetworkServiceState = .idle
    @Published var locationState: LocationServiceStatus?
    
    init(networkService: NetworkService, locationService: CoreLocationService) {
        self.networkService = networkService
        self.locationService = locationService
        self.locationService.completion = { [weak self] result in
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
        case success(ForecastWeatherResponse)
        case error(String)
    }
    
    func fetchWeather() {
        self.networkState = .loading
        var request = ForecastWeatherRequest()
        self.locationService.checkIfLocationServiceIsEnabled()
        
        if case .authorized(let location) = self.locationState {
            guard let coordinate = location?.coordinate else { return }
            request.queryItems["lat"] = "\(coordinate.latitude)"
            request.queryItems["lon"] = "\(coordinate.longitude)"
        }
        
        networkService.request(request) { [weak self] result in
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
