//
//  ErrorView.swift
//  SEWeather
//
//  Created by Иван Ровков on 12.07.2023.
//

import SwiftUI

struct ErrorView: View {
    var error: String
    
    var body: some View {
        VStack {
            Text("😓")
                .font(.system(size: 80))
                .padding(.bottom, -10)
            Text("Упс, сломалось")
                .font(.system(size: 30, weight: .semibold))
                .foregroundColor(.white)
            Text(error)
                .font(.system(size: 25))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
        }
    }
}
