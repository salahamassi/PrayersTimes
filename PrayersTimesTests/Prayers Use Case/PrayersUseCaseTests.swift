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
        var calendar = Calendar.init(identifier: .gregorian)
        calendar.locale = Locale(identifier: "PS-GZA")
        calendar.timeZone = TimeZone(abbreviation: "EEST")!

        XCTAssertEqual(sut.getPrayersTimes(with: calendar), items.todayItem)
    }
    
    func test_calculateNextPayerRemainingTimes() {
        let currentDate = Date(timeIntervalSince1970: 1619321400.0) // Sunday, April 25, 2021 6:30:00 AM GMT+03:00 DST
        let (sut, _) = makeSUT(with: { currentDate })
        var calendar = Calendar.init(identifier: .gregorian)
        calendar.locale = Locale(identifier: "PS-GZA")
        calendar.timeZone = TimeZone(abbreviation: "EEST")!
        guard let nextPrayer = sut.getNextPrayer(with: calendar) else { return XCTFail("Expect nextPrayer to have a value") }
        
        XCTAssertEqual(sut.calculateRemainingTime(to: nextPrayer, with: calendar), 22560) // 6 hours, 16 minutes and 0 seconds.
    }
    
    // - MARK: Helpers
    private func makeSUT(with date: @escaping () -> Date, file: StaticString = #filePath, line: UInt = #line) -> (sut: PrayersUseCase, items: (yesterdayItem: PrayersTimes, todayItem: PrayersTimes, tomorrowItem: PrayersTimes)) {
        let currentDate = date()
        
        var calendar = Calendar.init(identifier: .gregorian)
        calendar.locale = Locale(identifier: "PS-GZA")
        calendar.timeZone = TimeZone(abbreviation: "EEST")!

        let yesterdayDate = currentDate.adding(day: -1, with: calendar)
        let tomorrowDate = currentDate.adding(day: 1, with: calendar)
        
        let yesterdayItem = prayersTimes(using: yesterdayDate)
        let todayItem = prayersTimes(using: currentDate)
        let tomorrowItem = prayersTimes(using: tomorrowDate)
        
        let sut = PrayersUseCase(prayersTimes: [yesterdayItem, todayItem, tomorrowItem],
                                    currentDate: date)
        trackForMemoryLeaks(sut)
        return (sut, (yesterdayItem, todayItem, tomorrowItem))
    }
}
