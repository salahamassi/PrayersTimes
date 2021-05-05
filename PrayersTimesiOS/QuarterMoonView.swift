//
//  QuarterMoonView.swift
//  PrayersTimesiOS
//
//  Created by Salah Amassi on 06/05/2021.
//

import SwiftUI

public struct QuarterMoonView: View {
    
    @State private var animated = false
    @State private var circleHidden = true
    
    @State var size: CGFloat
    var third: Bool = true
    
    private var rotation: Angle {
        third ? .degrees(90) : -.degrees(90)
    }

    public init(size: CGFloat, third: Bool) {
        self.size = size
        self.third = third
    }
    
    public var body: some View {
        ZStack {
            Group {
                MoonView(size: size, stroke: 8)
                Circle()
                    .trim(from: 0, to: animated ? 0.5 : 1)
                    .rotationEffect(circleHidden ? .zero : rotation)
                    .scaleEffect(circleHidden ? .zero : 1)
            }
        }.onAppear() {
            withAnimation(.easeInOut(duration: 0.4).delay(1)) {
                circleHidden.toggle()
            }
            
            withAnimation(.easeOut(duration: 0.4).delay(1.4)) {
                animated.toggle()
            }
        }
    }
}

struct QuarterMoonView_Previews: PreviewProvider {
    static var previews: some View {
        QuarterMoonView(size: 256, third: true)
            .frame(width: 256, height: 256)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
