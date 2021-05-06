//
//  PrayersTimesView.swift
//  PrayersTimesiOS
//
//  Created by Salah Amassi on 02/05/2021.
//

import SwiftUI

struct PrayersTimesView: View {
    
    @State
    private var moonPhase: MoonPhases
    
    var size: CGFloat {
        128.0
    }
    
    public init(moonPhase: MoonPhases) {
        self.moonPhase = moonPhase
    }
    
    var body: some View {
        VStack(spacing: 32) {
            
            MoonPhaseView(size: size, moonPhase: $moonPhase)
                .frame(width: size, height: size)
            Text("Ramdan")
                .bold()
            Text("22, 1442 AH")
            Button(action: {
                let moonPhases: [MoonPhases] = [.newMoon, .waxingCrescent, .firstQuarter, .waxingGibbous, .fullMoon, .waningGibbous, .waningCrescent, .thirdQuarter]
                
                for (index, moonPhase) in moonPhases.enumerated() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index)) {
                        withAnimation {
                            self.moonPhase = moonPhase
                        }
                        print("moonPhase \(moonPhase)")
                    }
                }
            }, label: {
                Text("animate")
            })
        }
    }
}

struct PrayersTimesView_Previews: PreviewProvider {
    static var previews: some View {
        PrayersTimesView(moonPhase: .newMoon)
            .preferredColorScheme(.light)
    }
}
