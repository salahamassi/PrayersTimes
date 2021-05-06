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

struct MoonPhaseView_Previews: PreviewProvider {
    static var previews: some View {
        MoonPhaseView(size: 256,
                      moonPhase: Binding<MoonPhases>.constant(.thirdQuarter))
            .frame(width: 256, height: 256)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
