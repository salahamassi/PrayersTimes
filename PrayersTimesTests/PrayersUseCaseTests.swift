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
    
    func getNextPrayerDate() -> Date? {
        guard let prayersTimes = getPrayersTimes() else { return nil }
        let date = currentDate()
        let dates = [date,
                     prayersTimes.prayers[.fajr],
                     prayersTimes.prayers[.sunrise],
                     prayersTimes.prayers[.dhuhr],
                     prayersTimes.prayers[.asr],
                     prayersTimes.prayers[.sunset],
                     prayersTimes.prayers[.maghrib],
                     prayersTimes.prayers[.isha],
                     prayersTimes.prayers[.imsak],
                     prayersTimes.prayers[.midnight]].sorted()
        guard let firstIndex = dates.firstIndex(of: date) else { return nil }
        if firstIndex < dates.count - 1 {
            let index = firstIndex + 1
            return dates[index]
        }
        return nil
    }
}

class PrayersUseCaseTests: XCTestCase {
    
    func test_getPrayersTimes() {
        let (sut, items) = makeSUT(with: Date.init)
        
        XCTAssertEqual(sut.getPrayersTimes(), items.todayItem)
    }
    
    func test_getNextPrayerDate() {
        let currentDate = staticDate // Saturday, April 24, 2021 9:00:00 PM GMT
        let (sut, items) = makeSUT(with: { currentDate })
        
        let expectedPrayerDate = items.todayItem.prayers[.midnight] // Saturday, April 24, 2021 9:46:00 PM GMT
        
        XCTAssertEqual(sut.getNextPrayerDate(), expectedPrayerDate)
    }
    
    // - MARK: Helpers
    private func makeSUT(with date: @escaping () -> Date = { staticDate }, file: StaticString = #filePath, line: UInt = #line) -> (sut: PrayersUseCase, items: (yesterdayItem: PrayersTimes, todayItem: PrayersTimes, tomorrowItem: PrayersTimes)) {
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
