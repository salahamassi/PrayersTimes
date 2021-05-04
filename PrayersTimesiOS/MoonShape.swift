//
//  MoonShape.swift
//  PrayersTimesiOS
//
//  Created by Salah Amassi on 04/05/2021.
//

import SwiftUI

private extension View {
    func frame(width: CGFloat, height: CGFloat, animated: Bool) -> some View {
        let newWidth = animated ? width : .zero
        let newHeight = animated ? height : .zero
        return frame(width: newWidth, height: newHeight, alignment: .center)
    }
}

private extension Array {
    
    var lastIndex: Int {
        count - 1
    }
}

struct MoonView: View {
    
    @State var size: CGFloat
    
    @State private var animated: [Bool] = Array(repeating: false, count: 5)
    
    var body: some View {
        ZStack {
            
        
            Circle()
                .stroke(lineWidth: size / 16)
            
            Circle()
                .frame(width: size * 0.24, height: size * 0.24, animated: animated[0])
                .offset(x: -size * 0.2, y: -size * 0.2)
            
            Group {
                Circle()
                    .frame(width: size * 0.15, height: size * 0.15, animated: animated[1])
                Circle()
                    .frame(width: size * 0.17, height: size * 0.17, animated: animated[1])
                    .offset(x: size * 0.1, y: size * 0.1)
            }.offset(x: size * 0.04, y: -size * 0.2)
           
            Circle()
                .frame(width: size * 0.12, height: size * 0.12, animated: animated[2])
                .offset(x: size * 0.35, y: -size * 0.13)


            Circle()
                .frame(width: size * 0.2, height: size * 0.2, animated: animated[3])
                .offset(x: size * 0.3, y: size * 0.05)
            
            Group {
                Circle()
                    .frame(width: size * 0.1, height: size * 0.1, animated: animated[4])
                Circle()
                    .frame(width: size * 0.12, height: size * 0.12, animated: animated[4])
                    .offset(x: -size * 0.06, y: size * 0.1)
            }.offset(x: -size * 0.1, y: size * 0.15)
            
        }.onAppear() {
            for (index ,value) in animated.enumerated() {
                let duration = 0.4
                if index == animated.lastIndex {
                    withAnimation(Animation.interpolatingSpring(mass: 1, stiffness: 1, damping: 1, initialVelocity: 1).delay(duration * Double(index))) {
                        animated[index] = !value
                    }
                } else {
                    withAnimation(Animation.easeInOut(duration: duration).delay(duration * Double(index))) {
                        animated[index] = !value
                    }
                }
            }
        }
    }
}

struct HalalShape_Previews: PreviewProvider {
    static var previews: some View {
        MoonView(size: 512)
            .frame(width: 512, height: 512)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}