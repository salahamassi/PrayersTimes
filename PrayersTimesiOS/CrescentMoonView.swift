//
//  WaxingGibbousView.swift
//  PrayersTimesiOS
//
//  Created by Salah Amassi on 04/05/2021.
//

import SwiftUI

public struct CrescentMoonView: View {
    
    @State var size: CGFloat
    @State var animated: [Bool]  = Array(repeating: false, count: 2)
    @State private var ellipseHidden = true
    
    var waning: Bool = true
    
    private var offsetX: CGFloat {
        waning ? (size * 0.2) / 2 : -(size * 0.2) / 2
    }
    
    public var body: some View {
        ZStack {
            MoonView(size: size, stroke: 8)
            
            Ellipse()
                .frame(width: size,
                       height: size,
                       animatedWidth: size - (size * 0.2),
                       animatedHeight: size,
                       hidden: ellipseHidden,
                       animated: animated[0])
                .offset(x: animated[1] ? offsetX : 0)
                .animation(.easeInOut)
            
        }.onAppear() {
            let duration = 0.4
            let delay = (duration * 4)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                ellipseHidden = false
                for (index ,_) in animated.enumerated() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        animated[index].toggle()
                    }
                }
            }
        }
    }
}

struct CrescentMoonView_Previews: PreviewProvider {
    static var previews: some View {
        CrescentMoonView(size: 512, waning: false)
            .frame(width: 512, height: 512)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
