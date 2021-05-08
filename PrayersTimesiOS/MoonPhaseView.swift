//
//  MoonPhaseView.swift
//  PrayersTimesiOS
//
//  Created by Salah Amassi on 06/05/2021.
//

import SwiftUI


struct CrescentShape: Shape {
    
    let size: CGFloat
    let moonPhase: MoonPhases
    
    var animatableData: MoonPhases {
        moonPhase
    }
    
    private var arc: (startAngle: Angle, endAngle: Angle) {
        switch moonPhase {
        case .newMoon:
            return (startAngle: .degrees(0), endAngle: .degrees(360))
        case .waxingCrescent, .firstQuarter, .waxingGibbous, .waningGibbous:
            return (startAngle: .degrees(90), endAngle: .degrees(270))
        case .fullMoon:
            return (startAngle: .degrees(360), endAngle: .degrees(0))
        case .waningCrescent, .thirdQuarter:
            return (startAngle: -.degrees(90), endAngle: -.degrees(270))
        }
    }
    
    private var shouldDrawQuadCurve: Bool {
        moonPhase == .waxingCrescent ||
        moonPhase == .waxingGibbous ||
        moonPhase == .waningGibbous ||
        moonPhase == .waningCrescent
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        path.addArc(center: center,
                    radius: size / 2,
                    startAngle: arc.startAngle,
                    endAngle: arc.endAngle,
                    clockwise: false)
 
        if shouldDrawQuadCurve {
            let startPoint = CGPoint(x: rect.midX, y: rect.minY)
            let endPoint = CGPoint(x: rect.midX, y: rect.maxY)
            let controlPointOffset = moonPhase == .waningCrescent ? (size * 0.2) : 0
            let controlPoint =
                moonPhase == .waningCrescent
                ? CGPoint(x: rect.maxX + controlPointOffset, y: rect.midY)
                : CGPoint(x: rect.minX, y: rect.midY)
            
            path.move(to: startPoint)
            path.addQuadCurve(to: endPoint, control: controlPoint)
            if moonPhase == .waningGibbous {
                path = path.rotation(.degrees(180), anchor: .center).path(in: rect)
            }
        }
        return path
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
        MoonView(size: size, stroke: 0.0) {
            CrescentShape(size: size, moonPhase: moonPhase.wrappedValue)
                .fill(Color.darkSideMoonColor)
        }.onAppear() {
            withAnimation(.easeInOut(duration: 0.4).delay(1)) {
                moonPhaseViewHidden.toggle()
            }
            
            withAnimation(.easeOut(duration: 0.4).delay(1.4)) {
                animated.toggle()
            }
        }
    }
}

struct MoonPhaseView_Previews: PreviewProvider {
    static var previews: some View {
        MoonPhaseView(size: 256,
                      moonPhase: Binding<MoonPhases>.constant(.waningGibbous))
            .frame(width: 256, height: 256)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
