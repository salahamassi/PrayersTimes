//
//  MoonView.swift
//  PrayersTimesiOS
//
//  Created by Salah Amassi on 04/05/2021.
//

import SwiftUI

private extension Array {
    
    var lastIndex: Int {
        count - 1
    }
}

public enum MoonPhases {
    case newMoon
    case waxingCrescent
    case firstQuarter
    case waxingGibbous
    case fullMoon
    case waningGibbous
    case waningCrescent
    case thirdQuarter
}

public struct MoonView<Content: View>: View {
    
    @State
    private var animated: [Bool] = Array(repeating: false, count: 5)
    
    private let size: CGFloat
    private let stroke: CGFloat
    @ViewBuilder
    private let content: Content
    
    public init(size: CGFloat, stroke: CGFloat, content: () -> Content) {
        self.content = content()
        self.size = size
        self.stroke = stroke
    }
    
    public var body: some View {
        ZStack {
            
            Circle()
                .fill(Color.systemBackground)
            
            Circle()
                .stroke(lineWidth: stroke)
            
            content
            
            Circle()
                .frame(width: size * 0.24,
                       height: size * 0.24)
                .scaleEffect(animated[0] ? 1 : .zero)
                .offset(x: -size * 0.2, y: -size * 0.2)
            
            Group {
                Circle()
                    .frame(width: size * 0.15,
                           height: size * 0.15)
                    .scaleEffect(animated[1] ? 1 : .zero)
                Circle()
                    .frame(width: size * 0.17,
                           height: size * 0.17)
                    .scaleEffect(animated[1] ? 1 : .zero)
                    .offset(x: size * 0.1, y: size * 0.1)
            }.offset(x: size * 0.04, y: -size * 0.2)
            
            Circle()
                .frame(width: size * 0.12,
                       height: size * 0.12)
                .scaleEffect(animated[2] ? 1 : .zero)
                .offset(x: size * 0.35, y: -size * 0.13)
            
            Circle()
                .frame(width: size * 0.2,
                       height: size * 0.2)
                .scaleEffect(animated[3] ? 1 : .zero)
                .offset(x: size * 0.3, y: size * 0.05)
            
            Group {
                Circle()
                    .frame(width: size * 0.1,
                           height: size * 0.1)
                    .scaleEffect(animated[4] ? 1 : .zero)
                Circle()
                    .frame(width: size * 0.12,
                           height: size * 0.12)
                    .scaleEffect(animated[4] ? 1 : .zero)
                    .offset(x: -size * 0.06, y: size * 0.1)
            }.offset(x: -size * 0.1, y: size * 0.15)
            
        }.onAppear() {
            for (index ,value) in animated.enumerated() {
                let duration = 0.3
                if index == animated.lastIndex {
                    let animation: Animation = .interpolatingSpring(mass: 0.4,
                                                                    stiffness: 1,
                                                                    damping: 0.9,
                                                                    initialVelocity: 1)
                    withAnimation(animation.delay(duration * Double(index))) {
                        animated[index] = !value
                    }
                } else {
                    let animation: Animation = .easeOut(duration: duration)
                    withAnimation(animation.delay(duration * Double(index))) {
                        animated[index] = !value
                    }
                }
            }
        }
    }
}
