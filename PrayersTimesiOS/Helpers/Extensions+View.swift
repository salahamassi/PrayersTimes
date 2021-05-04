//
//  Extensions+View.swift
//  PrayersTimesiOS
//
//  Created by Salah Amassi on 04/05/2021.
//

import SwiftUI

extension View {
    
   func frame(width: CGFloat, height: CGFloat, animated: Bool) -> some View {
       let newWidth = animated ? width : .zero
       let newHeight = animated ? height : .zero
       return frame(width: newWidth, height: newHeight)
   }
}
