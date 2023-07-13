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
                                DetailWeatherView(weatherInfo: currentWeather)
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

struct DetailWeatherView: View {
    
    var weatherInfo: CurrentWeatherResponse
    
    var body: some View {
        VStack {
            Text("\(weatherInfo.name), \(weatherInfo.sys.country)")
                .font(.system(size: 40, weight: .medium))
                .foregroundColor(.white)

            HStack {
                Image(systemName: "cloud.sun.fill")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                VStack(alignment: .center) {
                    Text("\(Int(weatherInfo.main.temp))°C")
                        .font(.system(size: 60, weight: .medium))
                    Text(weatherInfo.weather.first?.description ?? "")
                }
                .padding(.leading, 20)
                .foregroundColor(.white)
            }
            
            Text("It seems to be cool outside, it is recommended to dress warmly so as not to freeze")
                .multilineTextAlignment(.leading)
                .foregroundColor(.white)
                .font(.system(size: 20))
                .frame(maxWidth: .infinity)
                .padding(15)
                .background(Color(.black).opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 15))

            HStack {
                VStack(alignment: .leading) {
                    WeatherDetailCell("wind", title: "Wind", value: "\(weatherInfo.wind.speed) mps")
                    WeatherDetailCell("barometer", title: "Pressure", value: "\(weatherInfo.main.pressure) mmHg")
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    WeatherDetailCell("humidity.fill", title: "Humidity", value: "\(weatherInfo.main.humidity)%")
                    WeatherDetailCell("thermometer.sun.fill", title: "Temperature", value: "\(Int(weatherInfo.main.tempMin))°C - \(Int(weatherInfo.main.tempMax))°C")
                }
            }
            .foregroundColor(.white)
            .padding(.top, 20)
            
//            Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 55.33, longitude: 86.08), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))), interactionModes: [.all])
//                .frame(height: 300)
//                .clipShape(RoundedRectangle(cornerRadius: 15))
//                .padding(.top, 20)

            Spacer()
        }
    }
    
    func WeatherDetailCell(_ imageName: String, title: String, value: String) -> some View {
        HStack {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            VStack(alignment: .leading) {
                Text(title)
                    .bold()
                    .font(.title3)
                Text(value)
                    .lineLimit(1)
            }
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
