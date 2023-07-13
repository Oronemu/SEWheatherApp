//
//  MainView.swift
//  SEWeather
//
//  Created by Иван Ровков on 11.07.2023.
//

import SwiftUI
import MapKit

struct MainView: View {
    
    @StateObject var viewModel: CurrentWeatherViewModel = .init(networkService: DefaultNetworkService(), locationService: CoreLocationService())
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .init("FrameBackground")]),
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                
                GeometryReader { geometry in
                    ScrollView(showsIndicators: false) {
                        VStack {
                            switch viewModel.networkState {
                            case .idle:
                                EmptyView()
                            case .loading:
                                CircullarLoadingView(color: .white, lineCap: .round)
                                    .frame(width: geometry.size.width - 40)
                                    .frame(minHeight: geometry.size.height)
                            case .success(let currentWeather):
                                WeatherView(currentWeather: currentWeather, viewModel: viewModel)
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

struct WeatherView: View {
    var currentWeather: CurrentWeather
    var viewModel: CurrentWeatherViewModel

    var body: some View {
        VStack {
            VStack {
                VStack {
                    Text("Current Location")
                        .font(.system(size: 30))
                    HStack {
                        AsyncImage(withURL: "https://openweathermap.org/img/wn/\(currentWeather.weather.first?.icon ?? "")@2x.png")
                        Text("\(currentWeather.name), \(currentWeather.sys.country)")
                            .font(.system(size: 20))
                    }
                    .padding(.top, -20)
                }

                VStack(alignment: .center) {
                    Text("\(Int(currentWeather.main.temp))°")
                        .font(.system(size: 80, weight: .thin))
                    Group {
                        Text(currentWeather.weather.first?.description.capitalized ?? "")
                        HStack {
                            Text("Max: \(Int(currentWeather.main.tempMax))°")
                            Text("Min: \(Int(currentWeather.main.tempMin))")
                        }
                    }
                    .font(.system(size: 18, weight: .semibold))
                }
                .padding(.top, -15)
            }
            .foregroundColor(.white)
            
            Text(viewModel.advice)
                .multilineTextAlignment(.leading)
                .foregroundColor(.white)
                .font(.system(size: 18))
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(Color(.black).opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
            DetailWeatherView(weatherInfo: currentWeather, viewModel: viewModel)
                .padding(.top, -15)
        }
    }
}

struct DetailWeatherView: View {
    
    var weatherInfo: CurrentWeather
    var viewModel: CurrentWeatherViewModel
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    WeatherDetailCell("wind", title: "Wind", value: "\(weatherInfo.wind.speed) mps")
                    WeatherDetailCell("barometer", title: "Pressure", value: "\(weatherInfo.main.pressure) mmHg")
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    WeatherDetailCell("humidity.fill", title: "Humidity", value: "\(weatherInfo.main.humidity)%")
                    WeatherDetailCell("thermometer.sun.fill", title: "Feels like", value: "\(Int(weatherInfo.main.feelsLike))°C")
                }
            }
            .foregroundColor(.white)
            .padding(.top, 20)
            
            if case .authorized(let location) = viewModel.locationState {
                VStack(alignment: .leading) {
                    HStack {
                        Group {
                            Image(systemName: "location.fill")
                            Text("Location")
                        }
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        Spacer()
                    }
                    
                    Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))), interactionModes: [.all])
                        .frame(height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                    Text("lat: \(location!.coordinate.latitude), lot: \(location!.coordinate.longitude)")
                        .foregroundColor(.white)
                    
                }
                .padding(10)
                .background(Color(.black).opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            

            Spacer()
        }
    }
    
    func WeatherDetailCell(_ imageName: String, title: String, value: String) -> some View {
        HStack {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 35, height: 35)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                Text(value)
            }
            .lineLimit(1)
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.black).opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
