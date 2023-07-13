//
//  WelcomeView.swift
//  SEWeather
//
//  Created by Иван Ровков on 12.07.2023.
//

import SwiftUI

struct OnBoardingView: View {
    
    @StateObject var viewModel: OnBoardingViewModel = OnBoardingViewModel(locationService: CoreLocationService())
    @State private var buttonClicked: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .init("FrameBackground")]), startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
            
            VStack {
                VStack {
                    Image(systemName: "cloud.sun.fill")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: 180, height: 180)
                    Text("Welcome to SEWeather!")
                        .font(.system(size: 30, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    Text("In this application, you can watch the weather in your city at any time. Even when you don't have an internet connection.")
                        .font(.system(size: 20))
                }
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                
                Group {
                    switch viewModel.state {
                    case .authorized(_):
                        Text("KAVO")
                    case .notDetermined:
                        VStack {
                            Button {
                                viewModel.checkIfLocationServiceIsEnabled()
                                buttonClicked = true
                            } label: {
                                HStack {
                                    Image(systemName: "location.fill")
                                    Text("Share my current location")
                                }
                                .padding()
                                .background(Color(.black).opacity(0.15))
                                .clipShape(Capsule())
                            }
                            .padding(.top, 25)
                        }
                    case .restricted:
                        Text("For the application to work, enable location services. To do this, go to \"Settings\" - \"SEWeatherApp\" - \"Location Services\"")
                    case .denied:
                        Text("For the application to work, enable location services. To do this, go to \"Settings\" - \"SEWeatherApp\" - \"Location Services\"")
                    case .disabled:
                        Text("For the application to work, enable location services. To do this, go to \"Security and Privacy\" - \"Location Services\"")
                    }
                }
                .padding(.top, 20)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            }
            .padding()
        }
        .onAppear() {
            if buttonClicked { viewModel.checkIfLocationServiceIsEnabled() }
        }
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}
