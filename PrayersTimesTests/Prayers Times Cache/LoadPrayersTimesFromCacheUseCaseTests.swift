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
    
    func test_load_deliversCachedPrayersTimesOnTheSameMonth() {
        let items = prayersTimesArray(using: TimeZone(abbreviation: "GMT+3")!)
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
    
    func test_load_deliversNoPrayersTimesOnNotTheSameMonth() {
        let items = prayersTimesArray(using: TimeZone(abbreviation: "GMT+3")!)
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
    
    func test_load_hasNoSideEffectsOnRetrievalError() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        store.completeRetrieval(with: anyNSError())
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectsOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        store.completeRetrievalWithEmptyCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectsOnTheSameMonthCache() {
        let items = prayersTimesArray(using: TimeZone(abbreviation: "GMT+3")!)
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
    
    func test_load_hasNoSideEffectsOnNotTheSameMonthCache() {
        let items = prayersTimesArray(using: TimeZone(abbreviation: "GMT+3")!)
        let fixedCurrentDate = Date()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        let monthOffsets = [1, -1, 2, -2]
        for (index, monthOffset) in monthOffsets.enumerated() {
            sut.load { _ in }
            
            let notSameMonthDate = fixedCurrentDate.adding(month: monthOffset)
            store.completeRetrieval(with: items.local,
                                    timestamp: notSameMonthDate,
                                    at: index)
        }
        XCTAssertEqual(store.receivedMessages, [.retrieve,
                                                .retrieve,
                                                .retrieve,
                                                .retrieve])
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let store = PrayersTimesStoreSpy()
        var sut: LocalPrayersTimesLoader? = LocalPrayersTimesLoader(store: store, currentDate: Date.init)

        var receivedResults = [LocalPrayersTimesLoader.LoadResult]()
        sut?.load { receivedResults.append($0) }

        sut = nil
        store.completeRetrievalWithEmptyCache()

        XCTAssertTrue(receivedResults.isEmpty)
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
}
