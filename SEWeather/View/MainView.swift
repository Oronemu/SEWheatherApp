//
//  MainView.swift
//  SEWeather
//
//  Created by Иван Ровков on 11.07.2023.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var viewModel: WeatherViewModel = .init(networkService: DefaultNetworkService())
    
    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.currentState {
                case .idle:
                    Text("Стоим")
                case .loading:
                    Text("Грузим-работаем")
                case .success(let weatherResponse):
                    Text(weatherResponse.current.weather.first?.description ?? "")
                }
                Button {
                    viewModel.fetchWeather()
                } label: {
                    Text("Click me")
                }
            }
            .navigationTitle("Прогноз на сегодня")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
