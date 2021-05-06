//
//  MoonPhaseView.swift
//  PrayersTimesiOS
//
//  Created by Salah Amassi on 06/05/2021.
//

import SwiftUI


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
            Ellipse()
                .trim(for: moonPhase.wrappedValue, animated: animated)
                .rotationEffect(for: moonPhase.wrappedValue, animated: animated)
                .frame(for: moonPhase.wrappedValue, size: size)
                .scaleEffect(moonPhaseViewHidden ? .zero : 1)
                .scaleEffect(for: moonPhase.wrappedValue, animated: animated)
                .offset(for: moonPhase.wrappedValue, using: size, animated: animated)
                .overlay(for: moonPhase.wrappedValue, size: size, animated: animated)
        }.onAppear() {
            withAnimation(.easeInOut(duration: 0.4).delay(1)) {
                moonPhaseViewHidden.toggle()
            }
            
            withAnimation(.easeOut(duration: 0.4).delay(1.4)) {
                animated.toggle()
            }
        }
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

private extension View {
    
    func overlay(for moonPhase: MoonPhases, size: CGFloat, animated: Bool) -> some View {
        switch moonPhase {
        case .waxingGibbous:
            return AnyView(overlay(Ellipse()
                            .fill(Color.systemBackground)
                            .scaleEffect(x: animated ? 0.8 : 1)
                            .offset(x: animated ?  (size * 0.2) / 2 : 0)))
        case .waningGibbous:
            return AnyView(overlay(Ellipse()
                            .fill(Color.systemBackground)
                            .scaleEffect(x: animated ? 0.8 : 1)
                            .offset(x: animated ?  -(size * 0.2) / 2 : 0)))
        default:
            return AnyView(scaleEffect(1))
        }
        
    }
    
    func frame(for moonPhase: MoonPhases, size: CGFloat) -> some View {
        switch moonPhase {
        case .fullMoon:
            return AnyView(frame(width: .zero, height: .zero))
        default:
            return AnyView(frame(width: size, height: size))
        }
    }
    
    func scaleEffect(for moonPhase: MoonPhases, animated: Bool) -> some View {
        switch moonPhase {
        case .waxingCrescent, .waningCrescent:
            return AnyView(scaleEffect(x: animated ? 0.8 : 1))
        default:
            return AnyView(scaleEffect(1))
        }
    }
    
    func offset(for moonPhase: MoonPhases, using size: CGFloat, animated: Bool) -> some View {
        switch moonPhase {
        case .waxingCrescent:
            return AnyView(offset(x: animated ?  -(size * 0.2) / 2 : 0))
        case .waningCrescent:
            return AnyView(offset(x: animated ?  (size * 0.2) / 2 : 0))
        case .waxingGibbous:
            return AnyView(offset(x: -1))
        case .waningGibbous:
            return AnyView(offset(x: 1))
        default:
            return AnyView(offset())
        }
    }
    
    func rotationEffect(for moonPhase: MoonPhases, animated: Bool) -> some View {
        switch moonPhase {
        case .firstQuarter:
            return  AnyView(rotationEffect(animated ? -.degrees(90) : .zero ))
        case .thirdQuarter:
            return  AnyView(rotationEffect(animated ? .degrees(90) : .zero ))
        default:
            return AnyView(rotationEffect(.zero))
        }
    }
}

private extension Shape {
    
    func trim(for moonPhase: MoonPhases, animated: Bool) -> some Shape {
        switch moonPhase {
        case .firstQuarter, .thirdQuarter:
            return trim(from: 0.0, to: animated ? 0.5 : 1.0)
        default:
            return trim()
        }
    }
}

struct MoonPhaseView_Previews: PreviewProvider {
    static var previews: some View {
        MoonPhaseView(size: 256,
                      moonPhase: Binding<MoonPhases>.constant(.waxingCrescent))
            .frame(width: 256, height: 256)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
