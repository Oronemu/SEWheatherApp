//
//  MainView.swift
//  SEWeather
//
//  Created by Иван Ровков on 11.07.2023.
//

import SwiftUI
import MapKit

struct MainView: View {
    
    @StateObject var viewModel: CurrentWeatherViewModel = .init(networkManager: DefaultNetworkManager(), locationManager: CoreLocationManager())
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(showsIndicators: false) {
                    switch viewModel.networkState {
                    case .idle:
                        EmptyView()
                    case .loading:
                        CircullarLoadingView(color: .white, lineCap: .round)
                    case .success:
                        WeatherView(viewModel: viewModel)
                    case .error(let error):
                        ErrorView(error: error)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.blue, .init("FrameBackground")]),
                    startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea())
            .onAppear {
                viewModel.loadData()
            }
        }
    }
}

struct WeatherView: View {
    var viewModel: CurrentWeatherViewModel
    
    var body: some View {
        VStack {
            VStack {
                Text("Current Location")
                    .font(.system(size: 30))
                HStack {
                    Image(systemName: "cloud.sun.fill")
                    Text("\(viewModel.currentWeather?.name ?? ""), \(viewModel.currentWeather?.sys?.country ?? "")")
                        .font(.system(size: 20))
                }

                VStack(alignment: .center) {
                    Text(String(Int(viewModel.currentWeather?.main?.temp ?? 0)) + "°")
                        .font(.system(size: 80, weight: .thin))
                    VStack {
                        Text(viewModel.advice)
                        HStack {
                            Text("Max: \(Int(viewModel.currentWeather?.main?.tempMax ?? 0))°")
                            Text("Min: \(Int(viewModel.currentWeather?.main?.tempMin ?? 0))°")
                        }
                    }
                }
            }
            
            DetailsView(viewModel: viewModel)
                .padding(.top, 20)
        }
    }
}

struct DetailsView: View {
    var viewModel: CurrentWeatherViewModel
    
    var body: some View {
        VStack {
            ForEach(1...3, id: \.self) { num in
                Text(String(num))
            }
        }
    }
}

//AsyncImage(withURL: "https://openweathermap.org/img/wn/\(currentWeather.weather.first?.icon ?? "")@2x.png")

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
