//
//  CalculateRemainingTimeToNextPrayerUseCaseTests.swift
//  PrayersTimesTests
//
//  Created by Salah Amassi on 25/04/2021.
//

import XCTest

class CalculateRemainingTimeToNextPrayerUseCase {
    
    var remaningTime: Double = 0
    
    
}

class CalculateRemainingTimeToNextPrayerUseCaseTests: XCTestCase {

   
    func test_init_doesNotCalculateRemainingTime() {
        let sut = CalculateRemainingTimeToNextPrayerUseCase()
        XCTAssertEqual(sut.remaningTime, 0)
    }
}
