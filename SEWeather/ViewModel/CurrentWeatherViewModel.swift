//
//  da.swift
//  SEWeather
//
//  Created by Иван Ровков on 12.07.2023.
//

import Foundation

class CurrentWeatherViewModel: ObservableObject {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    @Published var currentState: State = .idle
    
    enum State {
        case idle
        case loading
        case success(CurrentWeatherResponse)
        case error(String)
    }
    
    func fetchWeather() {
        self.currentState = .loading
        let request = CurrentWeatherRequest()
        networkService.request(request) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.currentState = .success(response)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.currentState = .error(error.localizedDescription)
                }
            }
        }
    }
}
