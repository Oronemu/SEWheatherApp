//
//  ContentView.swift
//  SEWeather
//
//  Created by Иван Ровков on 11.07.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @State private var selectedTab: Int = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MainView()
                .tabItem {
                    Image(systemName: "location.fill")
                    Text("Home")
                }
                .tag(1)
            ForecastView()
                .tabItem {
                    Image(systemName: "cloud.sun.rain.fill")
                    Text("Forecast")
                }
                .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
