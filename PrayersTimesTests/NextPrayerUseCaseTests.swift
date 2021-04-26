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
    
    func getPrayersTimesForCurrentDate() -> PrayersTimes? {
        let calendar = Calendar.init(identifier: .gregorian)
        return prayersTimes.first(where: { calendar.isDate($0.day, inSameDayAs: currentDate()) })
    }
}

class NextPrayerUseCaseTests: XCTestCase {
    
    func test_getPrayersTimesForCurrentDate() {
        let currentDate = Date()
        let yesterdayDate = currentDate.adding(day: -1)
        let tomorrowDate = currentDate.adding(day: 1)
        
        let yesterdayItem = uniqueItem(using: yesterdayDate)
        let todayItem = uniqueItem(using: currentDate)
        let tomorrowItem = uniqueItem(using: tomorrowDate)
        
        let sut = NextPrayerUseCase(prayersTimes: [yesterdayItem, todayItem, tomorrowItem], currentDate: Date.init)
        

        XCTAssertEqual(sut.getPrayersTimesForCurrentDate(), todayItem)
    }
}
