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
    let persistenceController = CoreDataManager.shared

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
