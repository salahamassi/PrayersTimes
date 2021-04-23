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
            sut.validateCache()
            store.completeRetrieval(with: items.local,
                                    timestamp: date,
                                    at: index)
        }
        XCTAssertEqual(store.receivedMessages, [.retrieve, .retrieve])
    }
    
    func test_validateCache_deleteOnNotTheSameMonthCache() {
        let items = uniqueItems()
        let fixedCurrentDate = Date()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        let monthOffsets = [1, -1, 2, -2]
        for (index, monthOffset) in monthOffsets.enumerated() {
            sut.validateCache()

            let notSameMonthDate = fixedCurrentDate.adding(month: monthOffset)
            store.completeRetrieval(with: items.local,
                                    timestamp: notSameMonthDate,
                                    at: index)
        }
        XCTAssertEqual(store.receivedMessages, [.retrieve,
                                                .deleteCachedPrayersTimes,
                                                .retrieve,
                                                .deleteCachedPrayersTimes,
                                                .retrieve,
                                                .deleteCachedPrayersTimes,
                                                .retrieve,
                                                .deleteCachedPrayersTimes])
    }
    
    // MARK: - Helpers
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalPrayersTimesLoader, store: PrayersTimesStoreSpy) {
        let store = PrayersTimesStoreSpy()
        let sut = LocalPrayersTimesLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
}
