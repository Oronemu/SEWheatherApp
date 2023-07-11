//
//  ForecastView.swift
//  SEWeather
//
//  Created by Иван Ровков on 11.07.2023.
//

import SwiftUI

struct ForecastView: View {
    
    @StateObject var viewModel: ForecastViewModel = .init(networkService: DefaultNetworkService())
    
    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.currentState {
                case .idle:
                    Text("Стоим")
                case .loading:
                    Text("Грузим-работаем")
                case .success(let weatherResponse):
                    VStack {
                        ScrollView {
                            ForEach(weatherResponse.daily, id: \.dt) { dayWeather in
                                VStack {
                                    Text(dayWeather.weather.first?.main ?? "")
                                    Text(dayWeather.weather.first?.description ?? "")
                                }
                            }
                        }
                    }
                }
                Button {
                    viewModel.fetchWeather()
                } label: {
                    Text("Click me")
                }
            }
            .navigationTitle("Прогноз на неделю")
        }
    }
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView()
    }
}
