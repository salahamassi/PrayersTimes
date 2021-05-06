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

public struct MoonPhaseView: View {
    
    private var moonPhase: Binding<MoonPhases>
    private let size: CGFloat
    
    @State
    private var moonPhaseViewHidden = true
    @State
    private var animated = false
    
    public init(size: CGFloat, moonPhase: Binding<MoonPhases>) {
        self.size = size
        self.moonPhase = moonPhase
    }
    
    public var body: some View {
        MoonView(size: size, stroke: getStroke(for: moonPhase.wrappedValue)) {            
            getView(for: moonPhase.wrappedValue)
        }.onAppear() {
            withAnimation(.easeInOut(duration: 0.4).delay(1)) {
                moonPhaseViewHidden.toggle()
            }
            
            withAnimation(.easeOut(duration: 0.4).delay(1.4)) {
                animated.toggle()
            }
        }
    }
    
    private func getView(for moonPhase: MoonPhases) -> some View {
        switch moonPhase {
        case .newMoon: return AnyView(newMoonView())
        case .waxingCrescent: return AnyView(waxingCrescentView())
        case .firstQuarter: return AnyView(firstQuarterMoonView())
        case .waxingGibbous: return AnyView(waxingGibbousView())
        case .fullMoon: return AnyView(HStack{})
        case .waningGibbous: return AnyView(waningGibbousView())
        case .thirdQuarter: return AnyView(thirdQuarterMoonView())
        case .waningCrescent: return AnyView(waningCrescentView())
        }
    }
    
    
    private func newMoonView() -> some View {
        Ellipse()
            .scaleEffect(moonPhaseViewHidden ? .zero : 1)
    }
    
    private func waxingCrescentView() -> some View {
        Ellipse()
            .frame(width: size,
                   height: size)
            .scaleEffect(moonPhaseViewHidden ? .zero : 1)
            .scaleEffect(x: animated ? 0.8 : 1)
            .offset(x: animated ? -(size * 0.2) / 2 : 0)
    }
    
    private func waningCrescentView() -> some View {
        Ellipse()
            .frame(width: size,
                   height: size)
            .scaleEffect(moonPhaseViewHidden ? .zero : 1)
            .scaleEffect(x: animated ? 0.8 : 1)
            .offset(x: animated ? (size * 0.2) / 2 : 0)
    }
    
    private func waxingGibbousView() -> some View {
        ZStack {
            Ellipse()
                .scaleEffect(moonPhaseViewHidden ? .zero : 1)
                .offset(x: 1)
            
            Ellipse()
                .fill(Color.systemBackground)
                .scaleEffect(x: animated ? 0.8 : 1)
                .offset(x: animated ?  -(size * 0.2) / 2 : 0)
        }
    }
    
    private func waningGibbousView() -> some View {
        ZStack {
            Ellipse()
                .scaleEffect(moonPhaseViewHidden ? .zero : 1)
                .offset(x: -1)
            
            Ellipse()
                .fill(Color.systemBackground)
                .scaleEffect(x: animated ? 0.8 : 1)
                .offset(x: animated ?  (size * 0.2) / 2 : 0)
        }
    }
    
    private func thirdQuarterMoonView() -> some View {
        Ellipse()
            .trim(from: 0, to: animated ? 0.5 : 1)
            .rotationEffect(moonPhaseViewHidden ? .zero :  .degrees(90))
            .scaleEffect(moonPhaseViewHidden ? .zero : 1)
    }
    
    private func firstQuarterMoonView() -> some View {
        Ellipse()
            .trim(from: 0, to: animated ? 0.5 : 1)
            .rotationEffect(moonPhaseViewHidden ? .zero :  -.degrees(90))
            .scaleEffect(moonPhaseViewHidden ? .zero : 1)
    }
    
    
    private func getStroke(for moonPhase: MoonPhases) -> CGFloat {
        switch moonPhase {
        case .newMoon, .fullMoon:
            return size / 16
        case .waxingCrescent, .waningCrescent, .firstQuarter, .thirdQuarter:
            return 8
        case .waxingGibbous, .waningGibbous:
            return 0
        }
    }
}

struct HalalShape_Previews: PreviewProvider {
    static var previews: some View {
        MoonPhaseView(size: 256,
                      moonPhase: Binding<MoonPhases>.constant(.thirdQuarter))
            .frame(width: 256, height: 256)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
