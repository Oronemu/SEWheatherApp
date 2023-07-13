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
    
    @Published var networkState: NetworkServiceState = .idle
    @Published var locationState: LocationServiceStatus?
    @Published var advice: String = ""
    
    init(networkService: NetworkService, locationService: LocationService) {
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
        case success(CurrentWeather)
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
        
        networkService.request(request) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.networkState = .success(response)
                    self.updateAdvice(for: response.main.temp)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.networkState = .error(error.localizedDescription)
                }
            }
        }
    }
    
    private func updateAdvice(for temperature: Double) {
        switch temperature {
        case ...(-30):
            self.advice = "It's extremely cold! Don't forget to wrap up in warm layers of clothing to keep warm"
        case -29...(-20):
            self.advice = "It's very cold. Wear a heavy coat and protect yourself from the cold and keep warm"
        case -19...(-10):
            self.advice = "It's chilly outside. Don't forget your scarf and gloves so you don't get sick!"
        case -9...0:
            self.advice = "It's cold. Wear a jacket or sweater to stay warm and don't get sick!"
        case 1...10:
            self.advice = "It's cool. It is recommended wear a light jacket or hoodie"
        case 11...20:
            self.advice = "It's mild and pleasant. Dress comfortably for the temperature"
        case 21...30:
            self.advice = "It's warm and sunny! Dress comfortably for the temperature"
        case 31...:
            self.advice = "It's very hot outside. Stay cool and hydrated, seek shade when possible"
        default:
            self.advice = "The temperature is outside the defined range"
        }
    }
}
