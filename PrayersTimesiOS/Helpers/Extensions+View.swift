//
//  Extensions+View.swift
//  PrayersTimesiOS
//
//  Created by Salah Amassi on 04/05/2021.
//

import SwiftUI

extension View {

    func frame(width: CGFloat, height: CGFloat, animatedWidth: CGFloat, animatedHeight: CGFloat, animated: Bool) -> some View {
        let newWidth = animated ? animatedWidth : width
        let newHeight = animated ? animatedHeight : height
        return frame(width: newWidth, height: newHeight)
    }
}
