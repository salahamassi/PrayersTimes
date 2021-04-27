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
        return prayers.first(where: { $0.date >  currentDate() && ($0.type != .sunset && $0.type != .sunrise && $0.type != .imsak && $0.type != .midnight) })
    }
}

class PrayersUseCaseTests: XCTestCase {
    
    func test_getPrayersTimes() {
        let (sut, items) = makeSUT(with: Date.init)
        
        XCTAssertEqual(sut.getPrayersTimes(), items.todayItem)
    }
    
    func test_getNextPrayerDate_fajr() {
        let currentDate = staticDate // Sunday, April 25, 2021 12:00:00 AM GMT+03:00 DST
        let sut = makeSUT(with: { currentDate })
        
        assertThat(sut, nextPrayerIs: .fajr) // Sunday, April 25, 2021 5:01:00 AM GMT+03:00 DST
    }
    
    func test_getNextPrayerDate_dhuhr() {
        let currentDate = Date(timeIntervalSince1970: 1619321400.0) // Sunday, April 25, 2021 6:30:00 AM GMT+03:00 DST
        let sut = makeSUT(with: { currentDate })
        
        assertThat(sut, nextPrayerIs: .dhuhr) // Sunday, April 25, 2021 12:46:00 PM GMT+03:00 DST
    }
    
    func test_getNextPrayerDate_asr() {
        let currentDate = Date(timeIntervalSince1970: 1619343960.0) // Sunday, April 25, 2021 12:46:00 PM GMT+03:00 DST
        let sut = makeSUT(with: { currentDate })
        
        assertThat(sut, nextPrayerIs: .asr) // Sunday, April 25, 2021 4:18:00 PM GMT+03:00 DST
    }
    
    func test_getNextPrayerDate_maghrib() {
        let currentDate = Date(timeIntervalSince1970: 1619356680.0) // Sunday, April 25, 2021 4:18:00 PM GMT+03:00 DST
        let sut = makeSUT(with: { currentDate })
        
        assertThat(sut, nextPrayerIs: .maghrib) // Sunday, April 25, 2021 7:02:00 PM GMT+03:00 DST
    }
    
    func test_getNextPrayerDate_isha() {
        let currentDate = Date(timeIntervalSince1970: 1619366520.0) // Sunday, April 25, 2021 7:02:00 PM GMT+03:00 DST
        let sut = makeSUT(with: { currentDate })
        
        assertThat(sut, nextPrayerIs: .isha) // Sunday, April 25, 2021 8:22:00 PM GMT+03:00 DST
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
    
    private func assertThat(_ sut: (sut: PrayersUseCase, items: (yesterdayItem: PrayersTimes, todayItem: PrayersTimes, tomorrowItem: PrayersTimes)), nextPrayerIs type: PrayerType, file: StaticString = #filePath, line: UInt = #line) {
        let expectedPrayer = sut.items.todayItem.prayers[type]
        
        let resultPrayer = sut.sut.getNextPrayerDate()
        
        XCTAssertEqual(resultPrayer?.date, expectedPrayer.date, file: file, line: line)
        XCTAssertEqual(resultPrayer?.type, expectedPrayer.type, file: file, line: line)
    }
}
