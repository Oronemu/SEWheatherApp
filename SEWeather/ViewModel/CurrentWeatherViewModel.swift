//
//  da.swift
//  SEWeather
//
//  Created by Иван Ровков on 12.07.2023.
//

import Foundation

class CurrentWeatherViewModel: ObservableObject {
    
    private let networkService: NetworkService
    private var locationService: LocationService
    
    init(networkService: NetworkService, locationService: LocationService) {
        self.networkService = networkService
        self.locationService = locationService
        self.locationService.completion = { result in
            switch result {
            case .success(let status):
                self.locationState = status
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @Published var networkState: NetworkServiceState = .idle
    @Published var locationState: LocationServiceStatus?

    enum NetworkServiceState {
        case idle
        case loading
        case success(CurrentWeatherResponse)
        case error(String)
    }
    
    func fetchWeather() {
        self.networkState = .loading
        var request = CurrentWeatherRequest()
        self.locationService.checkIfLocationServiceIsEnabled()
        if case .authorized(let location) = self.locationState {
            guard let location = location?.coordinate else { return }
            request.queryItems["lat"] = "\(location.latitude)"
            request.queryItems["lon"] = "\(location.longitude)"
        }
        print(request.queryItems)
        networkService.request(request) { result in
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
