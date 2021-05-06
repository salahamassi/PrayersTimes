//
//  GibbousMoonView.swift
//  PrayersTimesiOS
//
//  Created by Salah Amassi on 05/05/2021.
//

import SwiftUI

public struct GibbousMoonView: View {
    @State private var animated = false
    @State private var ellipseHidden = true
    
    @State var size: CGFloat
    var waning: Bool = true
    
    private var offsetX: CGFloat {
        waning ? (size * 0.2) / 2 : -(size * 0.2) / 2
    }

    public init(size: CGFloat, waning: Bool) {
        self.size = size
        self.waning = waning
    }
    
    public var body: some View {
        ZStack {
            Group {
                Ellipse()
                    .scaleEffect(ellipseHidden ? .zero : 1)
                    .offset(x: waning ? -1 : 1)

                Ellipse()
                    .fill(Color.systemBackground)
                    .scaleEffect(x: animated ? 0.8 : 1)
                    .offset(x: animated ? offsetX : 0)

                MoonView(size: size, stroke: 0)
                    .scaleEffect(animated ? 0.8 : 1)
                    .offset(x: animated ? offsetX : 0)
            }
        }.onAppear() {
            withAnimation(.easeInOut(duration: 0.4).delay(1)) {
                ellipseHidden.toggle()
            }
            
            withAnimation(.easeOut(duration: 0.4).delay(1.4)) {
                animated.toggle()
            }
        }
    }
}

struct GibbousMoonView_Previews: PreviewProvider {
    static var previews: some View {
        GibbousMoonView(size: 256, waning: false)
            .frame(width: 256, height: 256)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
