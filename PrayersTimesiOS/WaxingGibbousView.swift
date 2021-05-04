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
    @State private var ellipseHidden = true
    
    var body: some View {
        ZStack {
            MoonView(size: size, stroke: 8)
            
            Ellipse()
                .frame(width: size,
                       height: size,
                       animatedWidth: size - (size * 0.2),
                       animatedHeight: size,
                       hidden: ellipseHidden,
                       animated: animated[0])
                .offset(x: animated[1] ? (size * 0.2) / 2 : 0)
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

struct WaxingGibbousView_Previews: PreviewProvider {
    static var previews: some View {
        WaxingGibbousView(size: 512)
            .frame(width: 512, height: 512)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
