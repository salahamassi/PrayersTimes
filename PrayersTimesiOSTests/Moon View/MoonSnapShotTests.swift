//
//  MoonSnapShotTests.swift
//  PrayersTimesiOSTests
//
//  Created by Salah Amassi on 05/05/2021.
//

import XCTest
import PrayersTimesiOS

class MoonSnapShotTests: XCTestCase {
    
    func test_full_moon() {
        let sut = MoonView(size: 265, stroke: 16).animation(nil).padding()
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "FULL_MOON_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "FULL_MOON_dark")
    }
    
    func test_waning_crescent_moon() {
        let sut = CrescentMoonView(size: 256, waning: true)
            .frame(width: 256, height: 256)
            .animation(nil)
            .padding()

        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "WANING_CRESCENT_MOON_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "WANING_CRESCENT_MOON_dark")
    }
    
    func test_waxing_crescent_moon() {
        let sut = CrescentMoonView(size: 256, waning: false)
            .frame(width: 256, height: 256)
            .animation(nil)
            .padding()
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "WAXING_CRESCENT_MOON_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "WAXING_CRESCENT_MOON_dark")
    }
}
