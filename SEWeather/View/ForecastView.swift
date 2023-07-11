//
//  ForecastView.swift
//  SEWeather
//
//  Created by Иван Ровков on 11.07.2023.
//

import SwiftUI

struct ForecastView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Данные")
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
