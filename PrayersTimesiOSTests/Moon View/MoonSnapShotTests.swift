//
//  MoonSnapShotTests.swift
//  PrayersTimesiOSTests
//
//  Created by Salah Amassi on 05/05/2021.
//

import XCTest
import SwiftUI
import PrayersTimesiOS

class MoonSnapShotTests: XCTestCase {
    
    func test_full_moon() {
        let sut = makeSUT(for: .fullMoon)

        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "FULL_MOON_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "FULL_MOON_dark")
    }
    
    func test_waning_crescent_moon() {
        let sut = makeSUT(for: .waxingCrescent)

        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "WANING_CRESCENT_MOON_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "WANING_CRESCENT_MOON_dark")
    }
    
    func test_waxing_crescent_moon() {
        let sut = makeSUT(for: .waxingCrescent)

        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "WAXING_CRESCENT_MOON_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "WAXING_CRESCENT_MOON_dark")
    }
    
    func test_waning_gibbous_moon() {
        let sut = makeSUT(for: .waningGibbous)

        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "WANING_GIBBOUS_MOON_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "WANING_GIBBOUS_MOON_dark")
    }
    
    
    func test_waxing_gibbous_moon() {
        let sut = makeSUT(for: .waxingGibbous)

        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "WAXING_GIBBOUS_MOON_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "WAXING_GIBBOUS_MOON_dark")
    }
    
    func test_quarter_third_moon() {
        let sut = makeSUT(for: .thirdQuarter)

        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "QUARTER_THIRD_MOON_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "QUARTER_THIRD_MOON_dark")
    }
    
    func test_quarter_first_moon() {
        let sut = makeSUT(for: .firstQuarter)
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "QUARTER_FIRST_MOON_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "QUARTER_FIRST_MOON_dark")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(for phase: MoonPhases) -> some View {
        MoonPhaseView(size: 256, moonPhase: Binding.constant(phase))
            .frame(width: 256, height: 256)
            .animation(nil)
            .padding()
    }
}
