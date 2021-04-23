//
//  ValidatePrayersTimesCacheUseCaseTests.swift
//  PrayersTimesTests
//
//  Created by Salah Amassi on 23/04/2021.
//

import XCTest
import PrayersTimes

class ValidatePrayersTimesCacheUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_validateCache_deletesCacheOnRetrievalError() {
        let (sut, store) = makeSUT()

        sut.validateCache()
        store.completeRetrieval(with: anyNSError())

        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedPrayersTimes])
    }
    
    func test_validateCache_doesNotDeleteCacheOnEmptyCache() {
        let (sut, store) = makeSUT()

        sut.validateCache()
        store.completeRetrievalWithEmptyCache()

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_validateCache_doesNotDeleteOnTheSameMonthCache() {
        let items = uniqueItems()
        let fixedCurrentDate = Date()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        
        let sameMonthDate = fixedCurrentDate.startOfMonth
        let otherSameMonthDate = fixedCurrentDate.endOfMonth
        
        for (index, date) in [sameMonthDate, otherSameMonthDate].enumerated() {
            sut.load { _ in }
            store.completeRetrieval(with: items.local,
                                    timestamp: date,
                                    at: index)
        }
        XCTAssertEqual(store.receivedMessages, [.retrieve, .retrieve])
    }
    // MARK: - Helpers
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalPrayersTimesLoader, store: PrayersTimesStoreSpy) {
        let store = PrayersTimesStoreSpy()
        let sut = LocalPrayersTimesLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func uniqueItem() -> PrayersTimes {
        .init(fajr: "05:01 (EEST)",
              sunrise: "06:30 (EEST)",
              dhuhr: "12:46 (EEST)",
              asr: "16:18 (EEST)",
              sunset: "19:02 (EEST)",
              maghrib: "19:02 (EEST)",
              isha: "20:22 (EEST)",
              imsak: "04:50 (EEST)",
              midnight: "00:46 (EEST)",
              date: Date(timeIntervalSince1970: 1617343261))
    }
    
    private func uniqueItems() -> (models: [PrayersTimes], local: [LocalPrayersTimes]) {
        let models = [uniqueItem(), uniqueItem()]
        let local = models.map{ LocalPrayersTimes(fajr: $0.fajr,
                                                  sunrise: $0.sunrise,
                                                  dhuhr: $0.dhuhr,
                                                  asr: $0.asr,
                                                  sunset: $0.sunset,
                                                  maghrib: $0.maghrib,
                                                  isha: $0.isha,
                                                  imsak: $0.imsak,
                                                  midnight: $0.midnight,
                                                  date: $0.date) }
        return (models, local)
    }
    
    private func anyNSError() -> NSError {
        .init(domain: "any error", code: 0)
    }
}

private extension Date {
    
    func adding(month: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .month, value: month, to: self)!
    }
    
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
    
    var startOfMonth: Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        let startOfMonth = calendar.date(from: components)
        return startOfMonth ?? self
    }
    
    var endOfMonth: Date {
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return calendar.date(byAdding: components, to: startOfMonth) ?? self
    }
}
