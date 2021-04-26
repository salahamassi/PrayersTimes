//
//  NextPrayerUseCaseTests.swift
//  PrayersTimesTests
//
//  Created by Salah Amassi on 26/04/2021.
//

import XCTest
import PrayersTimes

class NextPrayerUseCase {
    
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

class NextPrayerUseCaseTests: XCTestCase {
    
    func test_getPrayersTimes() {
        let currentDate = Date()
        let yesterdayDate = currentDate.adding(day: -1)
        let tomorrowDate = currentDate.adding(day: 1)
        
        let yesterdayItem = uniqueItem(using: yesterdayDate)
        let todayItem = uniqueItem(using: currentDate)
        let tomorrowItem = uniqueItem(using: tomorrowDate)
        
        let sut = NextPrayerUseCase(prayersTimes: [yesterdayItem, todayItem, tomorrowItem], currentDate: Date.init)
        
        
        XCTAssertEqual(sut.getPrayersTimes(), todayItem)
    }
    
    func test_getNextPrayerDate() {
        let currentDate = staticDate // Saturday, April 24, 2021 9:00:00 PM GMT
        let yesterdayDate = currentDate.adding(day: -1)
        let tomorrowDate = currentDate.adding(day: 1)
        
        let yesterdayItem = uniqueItem(using: yesterdayDate)
        let todayItem = uniqueItem(using: currentDate)
        let tomorrowItem = uniqueItem(using: tomorrowDate)
        
        let sut = NextPrayerUseCase(prayersTimes: [yesterdayItem, todayItem, tomorrowItem], currentDate: { currentDate })
        let expectedPrayerDate = todayItem.prayers[.midnight] // Saturday, April 24, 2021 9:46:00 PM GMT
        XCTAssertEqual(sut.getNextPrayerDate(), expectedPrayerDate)
    }
}
