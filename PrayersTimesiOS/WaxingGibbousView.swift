//
//  WaxingGibbousView.swift
//  PrayersTimesiOS
//
//  Created by Salah Amassi on 04/05/2021.
//

import SwiftUI

struct WaxingGibbousView: View {
    
    @State var size: CGFloat
    @State var animated: [Bool]  = Array(repeating: false, count: 2)
    
    var body: some View {
        ZStack {
            MoonView(size: size, stroke: 8)
            
            Ellipse()
                .frame(width: size - (size * 0.2), height: size, animated: animated[0])
                .offset(x: animated[1] ? (size * 0.2) / 2 : 0)
                .animation(.easeInOut)
        }.onAppear() {
            for (index ,value) in animated.enumerated() {
                let duration = 0.4
                let delay = (duration * Double(index) + 2)
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    animated[index] = !value
                }
            }
        }
    }
}

struct WaxingGibbousView_Previews: PreviewProvider {
    static var previews: some View {
        WaxingGibbousView(size: 512)
            .frame(width: 512, height: 512)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
