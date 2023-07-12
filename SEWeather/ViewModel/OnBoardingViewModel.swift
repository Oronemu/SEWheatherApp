//
//  OnBoardingViewModel.swift
//  SEWeather
//
//  Created by Иван Ровков on 12.07.2023.
//

import Foundation
import CoreLocation
import SwiftUI

class OnBoardingViewModel: ObservableObject {
    @AppStorage("onBoardingIsShowed") private var onBoardingIsShowed = false
    
    private var locationService: LocationService
    
    init(locationService: LocationService) {
        self.locationService = locationService
        self.locationService.completion = { result in
            switch result {
            case .success(let status):
                self.state = status
                if case .authorized(_) = self.state {
                    self.onBoardingIsShowed = true
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @Published var state: LocationServiceStatus = .notDetermined
    
    func checkIfLocationServiceIsEnabled() {
        locationService.checkIfLocationServiceIsEnabled()
    }
}
