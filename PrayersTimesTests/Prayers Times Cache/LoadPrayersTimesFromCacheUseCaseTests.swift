//
//  LoadPrayersTimesFromCacheUseCaseTests.swift
//  PrayersTimesTests
//
//  Created by Salah Amassi on 22/04/2021.
//

import XCTest
import PrayersTimes

class LoadPrayersTimesFromCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_requestsCacheRetrieval() {
        let (sut, store) = makeSUT()
        
        sut.load() { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(retrievalError)) {
            store.completeRetrieval(with: retrievalError)
        }
    }
    
    func test_load_deliversNoPrayersTimesOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .success([])) {
            store.completeRetrievalWithEmptyCache()
        }
    }
    
    func test_load_deliversCachedPrayersTimesOnTheSameMonthDate() {
        let items = uniqueItems()
        let fixedCurrentDate = Date()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        let sameMonthDate = fixedCurrentDate.startOfMonth
        let otherSameMonthDate = fixedCurrentDate.endOfMonth
        
        for (index, date) in [sameMonthDate, otherSameMonthDate].enumerated() {
            expect(sut, toCompleteWith: .success(items.models), when: {
                store.completeRetrieval(with: items.local,
                                        timestamp: date,
                                        at: index)
            })
        }
    }
    
    func test_load_deliversNoPrayersTimesOnNotTheSameMonthDate() {
        let items = uniqueItems()
        let fixedCurrentDate = Date()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        let monthOffsets = [1, -1, 2, -2]
        for (index, monthOffset) in monthOffsets.enumerated() {
            let notSameMonthDate = fixedCurrentDate.adding(month: monthOffset)
            expect(sut, toCompleteWith: .success([]), when: {
                store.completeRetrieval(with: items.local,
                                        timestamp: notSameMonthDate,
                                        at: index)
            })
        }
    }
    
    func test_load_deletesCacheOnRetrievalError() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        store.completeRetrieval(with: anyNSError())
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedPrayersTimes])
    }
    
    func test_load_doesNotDeleteCacheOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        store.completeRetrievalWithEmptyCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_doesNotDeleteCacheOnTheSameMonthDate() {
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
        XCTAssertFalse(store.receivedMessages.contains(.deleteCachedPrayersTimes))
    }
    
    private func expect(_ sut: LocalPrayersTimesLoader, toCompleteWith expectedResult: LocalPrayersTimesLoader.LoadResult, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedPrayersTimes), .success(expectedPrayersTimes)):
                XCTAssertEqual(receivedPrayersTimes, expectedPrayersTimes, file: file, line: line)
                
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError.code, expectedError.code, file: file, line: line)
                XCTAssertEqual(receivedError.domain, expectedError.domain, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1.0)
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
