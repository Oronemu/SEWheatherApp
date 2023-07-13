//
//  da.swift
//  SEWeather
//
//  Created by Иван Ровков on 12.07.2023.
//

import Foundation
import CoreData

class CurrentWeatherViewModel: ObservableObject {
    
    private let networkManager: NetworkManager
    private var locationManager: LocationManager
    private let context = CoreDataManager.shared.container.viewContext
        
    @Published var networkState: NetworkState = .idle
    @Published var locationState: LocationManagerStatus?
    @Published var advice: String = ""
    @Published var currentWeather: CurrentWeatherEntity?
    
    init(networkManager: NetworkManager, locationManager: LocationManager) {
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
    
    enum NetworkState {
        case idle
        case loading
        case success
        case error(String)
    }
      
    private func saveWeatherData(weather: CurrentWeather) {
        guard let weatherEntity = NSEntityDescription.entity(forEntityName: "CurrentWeatherEntity", in: context) else { return }
        
        let entityObject = CurrentWeatherEntity(entity: weatherEntity, insertInto: context)
        
        entityObject.dt = weather.dt
        entityObject.name = weather.name
        entityObject.timezone = Int16(weather.timezone)
        
        guard let entity = NSEntityDescription.entity(forEntityName: "WeatherEntity", in: context) else { return }
        let weatherSet = NSMutableSet()
        
        for weatherData in weather.weather {
            let weatherEntity = WeatherEntity(entity: entity, insertInto: context)
            weatherEntity.main = weatherData.main
            weatherEntity.weatherDescription = weatherData.weatherDescription
            weatherEntity.icon = weatherData.icon
            
            weatherSet.add(weatherEntity)
        }
        entityObject.weather = weatherSet
        
        let mainEntity = MainEntity(context: context)
        mainEntity.temp = weather.main.temp
        mainEntity.feelsLike = weather.main.feelsLike
        mainEntity.tempMin = weather.main.tempMin
        mainEntity.tempMax = weather.main.tempMax
        mainEntity.pressure = Int16(weather.main.pressure)
        mainEntity.humidity = Int16(weather.main.humidity)
        entityObject.main = mainEntity
        
        let sysEntity = SysEntity(context: context)
        sysEntity.country = weather.sys.country
        entityObject.sys = sysEntity
        
        let windEntity = WindEntity(context: context)
        windEntity.speed = weather.wind.speed
        
        do {
            try context.save()
        } catch {
            print("error")
        }
        
        self.loadData()
    }
    
    func loadData() {
        let request = NSFetchRequest<CurrentWeatherEntity>(entityName: "CurrentWeatherEntity")
        
        do {
            currentWeather = try context.fetch(request).first
            if currentWeather == nil {
                self.fetchWeather()
            }
            self.networkState = .success
        } catch let error {
            self.networkState = .error(error.localizedDescription)
        }
    }
    
    private func fetchWeather() {
        self.networkState = .loading
        var request = CurrentWeatherRequest()
        self.locationManager.checkIfLocationServiceIsEnabled()
        
        if case .authorized(let location) = self.locationState {
            guard let location = location?.coordinate else { return }
            request.queryItems["lat"] = "\(location.latitude)"
            request.queryItems["lon"] = "\(location.longitude)"
        }
        
        networkManager.request(request) { result in
            switch result {
            case .success(let response):
                self.saveWeatherData(weather: response)
                DispatchQueue.main.async {
                    self.networkState = .success
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
