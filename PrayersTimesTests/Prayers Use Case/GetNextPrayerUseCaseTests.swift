//
//  GetNextPrayerUseCaseTests.swift
//  PrayersTimesTests
//
//  Created by Salah Amassi on 27/04/2021.
//

import XCTest
import PrayersTimes

class GetNextPrayerUseCaseTests: XCTestCase {

    func test_getNextPrayer_fajr() {
        let currentDate = staticDate // Sunday, April 25, 2021 12:00:00 AM GMT+03:00 DST
        let sut = makeSUT(with: { currentDate })
        
        assertThat(sut, nextPrayerIs: .fajr) // Sunday, April 25, 2021 5:01:00 AM GMT+03:00 DST
    }
    
    func test_getNextPrayer_dhuhr() {
        let currentDate = Date(timeIntervalSince1970: 1619321400.0) // Sunday, April 25, 2021 6:30:00 AM GMT+03:00 DST
        let sut = makeSUT(with: { currentDate })
        
        assertThat(sut, nextPrayerIs: .dhuhr) // Sunday, April 25, 2021 12:46:00 PM GMT+03:00 DST
    }
    
    func test_getNextPrayer_asr() {
        let currentDate = Date(timeIntervalSince1970: 1619343960.0) // Sunday, April 25, 2021 12:46:00 PM GMT+03:00 DST
        let sut = makeSUT(with: { currentDate })
        
        assertThat(sut, nextPrayerIs: .asr) // Sunday, April 25, 2021 4:18:00 PM GMT+03:00 DST
    }
    
    func test_getNextPrayer_maghrib() {
        let currentDate = Date(timeIntervalSince1970: 1619356680.0) // Sunday, April 25, 2021 4:18:00 PM GMT+03:00 DST
        let sut = makeSUT(with: { currentDate })
        
        assertThat(sut, nextPrayerIs: .maghrib) // Sunday, April 25, 2021 7:02:00 PM GMT+03:00 DST
    }
    
    func test_getNextPrayer_isha() {
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
        let expectedPrayer = sut.items.todayItem[type]
        
        let resultPrayer = sut.sut.getNextPrayer()
        
        XCTAssertEqual(resultPrayer?.date, expectedPrayer.date, file: file, line: line)
        XCTAssertEqual(resultPrayer?.type, expectedPrayer.type, file: file, line: line)
    }
}
