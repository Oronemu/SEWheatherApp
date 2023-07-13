//
//  ForecastView.swift
//  SEWeather
//
//  Created by Иван Ровков on 11.07.2023.
//

import SwiftUI

struct ForecastView: View {
    
    @StateObject var viewModel: ForecastViewModel = .init(networkService: DefaultNetworkService(), locationService: CoreLocationService())
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .init("FrameBackground")]),
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                
                GeometryReader { geometry in
                    ScrollView(showsIndicators: false) {
                        LazyVStack {
                            switch viewModel.networkState {
                            case .idle:
                                EmptyView()
                            case .loading:
                                CircullarLoadingView(color: .white, lineCap: .round)
                                    .frame(width: geometry.size.width - 40)
                                    .frame(minHeight: geometry.size.height)
                            case .success(let currentWeather):
                                DetailForecastView(forecastWeather: currentWeather)
                            case .error(let error):
                                ErrorView(error: error)
                                    .frame(width: geometry.size.width - 40)
                                    .frame(minHeight: geometry.size.height)
                            }
                        }
                        .padding()
                    }
                    .onAppear {
                        viewModel.fetchWeather()
                    }
                }
            }
        }
    }
}

struct DetailForecastView: View {
    
    var forecastWeather: ForecastWeather
    
    var body: some View {
        VStack(spacing: 20) {
            if forecastWeather.alerts != nil {
                let alert = forecastWeather.alerts?.first
                VStack(alignment: .leading) {
                    HStack {
                        Text("Уведомление")
                            .font(.title3)
                            .bold()
                        Spacer()
                        Text(alert!.event)
                    }
                    Text("Источник: \(alert!.senderName)")
                        .font(.system(size: 15))
                    Text(alert!.description.capitalizingFirstLetter())
                }
                .foregroundColor(.white)
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.black).opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
                
            ForEach(forecastWeather.daily, id: \.dt) { day in
                HStack(spacing: 20) {
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(day.dt.toString(format: "EEEE"))
                                        .font(.system(size: 25, weight: .semibold))
                                    AsyncImage(withURL: "https://openweathermap.org/img/wn/\(day.weather.first?.icon ?? "")@2x.png")
                                }
                                Text(day.summary)
                            }
                            .frame(maxWidth: 230)
                            
                            Spacer()
                            
                            VStack {
                                HStack {
                                    VStack {
                                        Image(systemName: "sun.max.fill")
                                        Text("\(Int(day.temp.day))°C")
                                    }
                                    Text("-")
                                    VStack {
                                        Image(systemName: "moon.fill")
                                        Text("\(Int(day.temp.night))°C")
                                    }
                                }
                                
                                Spacer()
                                
                                HStack {
                                    VStack {
                                        Image(systemName: "barometer")
                                        Text("\(day.pressure)")
                                        Text("mmHg")
                                            .font(.system(size: 10))
                                    }
                                    Spacer()
                                    VStack {
                                        Image(systemName: "wind")
                                        Text("\(Int(day.windSpeed))")
                                        Text("mps")
                                            .font(.system(size: 10))
                                    }
                                }
                            }
                            .frame(width: 100)
                            .font(.system(size: 15))
                        }
                        Divider()
                        
                        HStack {
                            HStack {
                                Image(systemName: "sunrise.fill")
                                    .renderingMode(.original)
                                Text("Sunrise: \(day.sunrise.toString(format: "HH:mm"))")
                            }
                            Spacer()
                            HStack {
                                Image(systemName: "sunset.fill")
                                    .renderingMode(.original)
                                Text("Sunset: \(day.sunset.toString(format: "HH:mm"))")
                            }
                        }
                    }
                }
                .foregroundColor(.white)
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.black).opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView()
    }
}
