//
//  PrayersTimesView.swift
//  PrayersTimesiOS
//
//  Created by Salah Amassi on 02/05/2021.
//

import SwiftUI

struct PrayersTimesView: View {
    
    @State private var animating: Bool = false
    
    var size: CGFloat {
        animating ? 265.0 : 128.0
    }
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                CrescentMoonView(size: size, waning: true)
                    .frame(width: size, height: size)
                CrescentMoonView(size: size, waning: false)
                    .frame(width: size, height: size)
                
                GibbousMoonView(size: size, waning: true)
                    .frame(width: size, height: size)
                
                GibbousMoonView(size: size, waning: false)
                    .frame(width: size, height: size)
                
                QuarterMoonView(size: size, third: true)
                    .frame(width: size, height: size)

                QuarterMoonView(size: size, third: false)
                    .frame(width: size, height: size)

                Text("Ramdan")
                    .bold()
                Text("22, 1442 AH")
            }.padding()
        }
    }
}

struct PrayersTimesView_Previews: PreviewProvider {
    static var previews: some View {
        PrayersTimesView()
            .preferredColorScheme(.dark)
    }
}
