//
//  SEWeatherApp.swift
//  SEWeather
//
//  Created by Иван Ровков on 11.07.2023.
//

import SwiftUI

@main
struct SEWeatherApp: App {
    @AppStorage("onBoardingIsShowed") private var onBoardingIsShowed = false
    
    var body: some Scene {
        WindowGroup {
            if onBoardingIsShowed {
                ContentView()
            } else {
                OnBoardingView()
            }
        }
    }
}
