//
//  SEWeatherApp.swift
//  SEWeather
//
//  Created by Иван Ровков on 11.07.2023.
//

import SwiftUI

@main
struct SEWeatherApp: App {
    let persistenceController = PersistenceController.shared
    @AppStorage("onBoardingIsShowed") private var onBoardingIsShowed = false
    
    var body: some Scene {
        WindowGroup {
            if onBoardingIsShowed {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                OnBoardingView()
            }
        }
    }
}
