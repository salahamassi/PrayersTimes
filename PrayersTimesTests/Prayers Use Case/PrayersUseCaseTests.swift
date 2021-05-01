//
//  NextPrayerUseCaseTests.swift
//  PrayersTimesTests
//
//  Created by Salah Amassi on 26/04/2021.
//

import XCTest
import PrayersTimes

class PrayersUseCaseTests: XCTestCase {
    
    func test_getPrayersTimes() {
        let (sut, items) = makeSUT(with: Date.init)
        
        XCTAssertEqual(sut.getPrayersTimes(), items.todayItem)
    }
    
    func test_calculateNextPayerRemainingTimes() {
        let currentDate = Date(timeIntervalSince1970: 1619321400.0) // Sunday, April 25, 2021 6:30:00 AM GMT+03:00 DST
        let (sut, _) = makeSUT(with: { currentDate })
        
        guard let nextPrayer = sut.getNextPrayer() else { return XCTFail("Expect nextPrayer to have a value") } // Sunday, April 25, 2021 12:46:00 PM GMT+03:00 DST (dhuhr)
        
        XCTAssertEqual(sut.calculateRemainingTime(to: nextPrayer), 22560) // 6 hours, 16 minutes and 0 seconds.
    }
    
    // - MARK: Helpers
    private func makeSUT(with date: @escaping () -> Date, file: StaticString = #filePath, line: UInt = #line) -> (sut: PrayersUseCase, items: (yesterdayItem: PrayersTimes, todayItem: PrayersTimes, tomorrowItem: PrayersTimes)) {
        let currentDate = date()
        let yesterdayDate = currentDate.adding(day: -1)
        let tomorrowDate = currentDate.adding(day: 1)
        
        let yesterdayItem = prayersTimes(using: yesterdayDate)
        let todayItem = prayersTimes(using: currentDate)
        let tomorrowItem = prayersTimes(using: tomorrowDate)
        
        let sut = PrayersUseCase(prayersTimes: [yesterdayItem, todayItem, tomorrowItem],
                                    currentDate: date)
        trackForMemoryLeaks(sut)
        return (sut, (yesterdayItem, todayItem, tomorrowItem))
    }
}
