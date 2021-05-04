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
    
    func frame(width: CGFloat, height: CGFloat, animatedWidth: CGFloat, animatedHeight: CGFloat, hidden: Bool, animated: Bool) -> some View {
        let newWidth = hidden ? .zero : animated ? animatedWidth : width
        let newHeight = hidden ? .zero : animated ? animatedHeight : height
        return frame(width: newWidth, height: newHeight)
    }
}
