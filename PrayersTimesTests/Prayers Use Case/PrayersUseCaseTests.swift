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
        
        guard let nextPrayer = sut.getNextPrayer() else { return XCTFail("Expect nextPrayer to have a value") }
        
        XCTAssertEqual(sut.calculateRemainingTime(to: nextPrayer), 22560) // 6 hours, 16 minutes and 0 seconds.
    }
    
    // - MARK: Helpers
    private func makeSUT(with date: @escaping () -> Date, file: StaticString = #filePath, line: UInt = #line) -> (sut: PrayersUseCase, items: (yesterdayItem: PrayersTimes, todayItem: PrayersTimes, tomorrowItem: PrayersTimes)) {
        let currentDate = date()
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(abbreviation: "GMT+3")!
        let yesterdayDate = currentDate.adding(day: -1, using: calendar)
        let tomorrowDate = currentDate.adding(day: 1, using: calendar)
        
        let yesterdayItem = prayersTimes(using: yesterdayDate, timeZone: TimeZone(abbreviation: "GMT+3")!)
        let todayItem = prayersTimes(using: currentDate, timeZone: TimeZone(abbreviation: "GMT+3")!)
        let tomorrowItem = prayersTimes(using: tomorrowDate, timeZone: TimeZone(abbreviation: "GMT+3")!)
        
        let sut = PrayersUseCase(prayersTimes: [yesterdayItem, todayItem, tomorrowItem],
                                 calendar: calendar,
                                 currentDate: date)
        trackForMemoryLeaks(sut)
        return (sut, (yesterdayItem, todayItem, tomorrowItem))
    }
}
