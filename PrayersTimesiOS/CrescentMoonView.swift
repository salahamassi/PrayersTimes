//
//  WaxingGibbousView.swift
//  PrayersTimesiOS
//
//  Created by Salah Amassi on 04/05/2021.
//

import SwiftUI

public struct CrescentMoonView: View {
    
    @State private var animated: [Bool]  = Array(repeating: false, count: 2)
    @State private var ellipseHidden = true
    
    @State var size: CGFloat
    var waning: Bool = true
    
    private var offsetX: CGFloat {
        waning ? (size * 0.2) / 2 : -(size * 0.2) / 2
    }
    
    public init(size: CGFloat, waning: Bool) {
        self.size = size
        self.waning = waning
    }
    
    public var body: some View {
        ZStack {
            MoonView(size: size, stroke: 8)
            Ellipse()
                .frame(width: size,
                       height: size,
                       animatedWidth: size - (size * 0.2),
                       animatedHeight: size,
                       animated: animated[0])
                .scaleEffect(ellipseHidden ? .zero : 1)
                .offset(x: animated[1] ? offsetX : 0)
        }.onAppear() {
            withAnimation(.easeInOut(duration: 0.4).delay(1)) {
                ellipseHidden.toggle()
            }

            withAnimation(.easeInOut(duration: 0.4).delay(1.4)) {
                animated[0].toggle()
                animated[1].toggle()
            }
        }
    }
}

struct CrescentMoonView_Previews: PreviewProvider {
    static var previews: some View {
        CrescentMoonView(size: 256, waning: true)
            .frame(width: 256, height: 256)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
