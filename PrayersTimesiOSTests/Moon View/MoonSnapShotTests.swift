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
    
    func test_waning_gibbous_moon() {
        let sut = GibbousMoonView(size: 256, waning: true)
            .frame(width: 256, height: 256)
            .animation(nil)
            .padding()
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "WANING_GIBBOUS_MOON_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "WANING_GIBBOUS_MOON_dark")
    }

    
    func test_waxing_gibbous_moon() {
        let sut = GibbousMoonView(size: 256, waning: false)
            .frame(width: 256, height: 256)
            .animation(nil)
            .padding()
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "WAXING_GIBBOUS_MOON_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "WAXING_GIBBOUS_MOON_dark")
    }
    
    func test_quarter_third_moon() {
        let sut = QuarterMoonView(size: 256, third: true)
            .frame(width: 256, height: 256)
            .animation(nil)
            .padding()
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "QUARTER_THIRD_MOON_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "QUARTER_THIRD_MOON_dark")
    }

    func test_quarter_first_moon() {
        let sut = QuarterMoonView(size: 256, third: false)
            .frame(width: 256, height: 256)
            .animation(nil)
            .padding()
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "QUARTER_FIRST_MOON_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "QUARTER_FIRST_MOON_dark")
    }
}
