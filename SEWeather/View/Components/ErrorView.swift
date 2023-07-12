//
//  ErrorView.swift
//  SEWeather
//
//  Created by Иван Ровков on 12.07.2023.
//

import SwiftUI

struct ErrorView: View {
    var error: String
    @State var isHapticWorked: Bool = false
    
    var body: some View {
        VStack {
            Text("😓")
                .font(.system(size: 80))
                .padding(.bottom, -10)
            Text("Oops, there seems to be an error.")
                .font(.system(size: 30, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            Text(error)
                .font(.system(size: 25))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
        }
        .onAppear {
            if !isHapticWorked {
                Haptic.shared.notify(.error)
                self.isHapticWorked.toggle()
            }
        }
    }
}
