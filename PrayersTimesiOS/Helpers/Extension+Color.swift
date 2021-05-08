//
//  Extension+Color.swift
//  PrayersTimesiOS
//
//  Created by Salah Amassi on 05/05/2021.
//

import SwiftUI

extension Color {
    
    static var systemBackground: Color {
        Color(UIColor.systemBackground)
    }
    
    static var darkSideMoonColor: Color {
        Color(red: 34/256, green: 61/256, blue: 94/256, opacity: 0.3)
    }
    
    static var lightSideMoonColor: Color {
        Color(red: 223/256, green: 225/256, blue: 228/256)
    }
    
    static var moonDotsColor: Color {
        Color(red: 184/256, green: 192/256, blue: 201/256)
    }

}
