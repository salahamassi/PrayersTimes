//
//  NextPrayerUseCaseTests.swift
//  PrayersTimesTests
//
//  Created by Salah Amassi on 26/04/2021.
//

import XCTest
import PrayersTimes

class PrayersUseCase {
    
    let currentDate: ()-> Date
    let prayersTimes: [PrayersTimes]
    
    init(prayersTimes: [PrayersTimes], currentDate: @escaping () -> Date) {
        self.prayersTimes = prayersTimes
        self.currentDate = currentDate
    }
    
    func getPrayersTimes() -> PrayersTimes? {
        let calendar = Calendar.init(identifier: .gregorian)
        return prayersTimes.first(where: { calendar.isDate($0.day, inSameDayAs: currentDate()) })
    }
    
    func getNextPrayerDate() -> Prayers.Prayer? {
        guard let prayersTimes = getPrayersTimes() else { return nil }
        let prayers = [prayersTimes.prayers[.fajr],
                     prayersTimes.prayers[.sunrise],
                     prayersTimes.prayers[.dhuhr],
                     prayersTimes.prayers[.asr],
                     prayersTimes.prayers[.sunset],
                     prayersTimes.prayers[.maghrib],
                     prayersTimes.prayers[.isha],
                     prayersTimes.prayers[.imsak],
                     prayersTimes.prayers[.midnight]]
        return prayers.first(where: { $0.date >  currentDate()})
    }
}

class PrayersUseCaseTests: XCTestCase {
    
    func test_getPrayersTimes() {
        let (sut, items) = makeSUT(with: Date.init)
        
        XCTAssertEqual(sut.getPrayersTimes(), items.todayItem)
    }
    
    func test_getNextPrayerDate() {
        let currentDate = staticDate // Sunday, April 25, 2021 12:00:00 AM GMT+03:00 DST
        let (sut, items) = makeSUT(with: { currentDate })
        
        let expectedPrayer = items.todayItem.prayers[.fajr] // Sunday, April 25, 2021 5:01:00 AM GMT+03:00 DST
        
        let resultPrayer = sut.getNextPrayerDate()
        
        XCTAssertEqual(resultPrayer?.date, expectedPrayer.date)
        XCTAssertEqual(resultPrayer?.type, expectedPrayer.type)
    }
    
    // - MARK: Helpers
    private func makeSUT(with date: @escaping () -> Date, file: StaticString = #filePath, line: UInt = #line) -> (sut: PrayersUseCase, items: (yesterdayItem: PrayersTimes, todayItem: PrayersTimes, tomorrowItem: PrayersTimes)) {
        let currentDate = date()
        let yesterdayDate = currentDate.adding(day: -1)
        let tomorrowDate = currentDate.adding(day: 1)
        
        let yesterdayItem = uniqueItem(using: yesterdayDate)
        let todayItem = uniqueItem(using: currentDate)
        let tomorrowItem = uniqueItem(using: tomorrowDate)
        
        let sut = PrayersUseCase(prayersTimes: [yesterdayItem, todayItem, tomorrowItem],
                                    currentDate: date)
        trackForMemoryLeaks(sut)
        return (sut, (yesterdayItem, todayItem, tomorrowItem))
    }
}
