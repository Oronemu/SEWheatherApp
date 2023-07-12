//
//  DateExtensions.swift
//  SEWeather
//
//  Created by Иван Ровков on 12.07.2023.
//

import Foundation

extension Date {
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self).capitalized
    }
    
    func dateAndTimetoString(format: String = "yyyy-MM-dd HH:mm") -> String {
       let formatter = DateFormatter()
       formatter.dateStyle = .short
       formatter.dateFormat = format
       return formatter.string(from: self)
   }
}
