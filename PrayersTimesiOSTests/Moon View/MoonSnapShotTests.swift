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
}
