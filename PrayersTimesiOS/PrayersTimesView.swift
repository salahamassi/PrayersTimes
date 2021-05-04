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
        ZStack {
            VStack(alignment: .leading, spacing: 8) {
                GibbousMoonView(size: size)
                    .frame(width: size, height: size)
                Text("Ramdan")
                    .bold()
                Text("22, 1442 AH")
            }
        }
    }
}

struct PrayersTimesView_Previews: PreviewProvider {
    static var previews: some View {
        PrayersTimesView()
    }
}
