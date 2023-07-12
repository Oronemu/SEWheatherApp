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
    
    init(networkService: NetworkService, locationService: CoreLocationService) {
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
        case success(ForecastWeatherResponse)
        case error(String)
    }
    
    func fetchWeather() {
        self.networkState = .loading
        let request = ForecastWeatherRequest()
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
