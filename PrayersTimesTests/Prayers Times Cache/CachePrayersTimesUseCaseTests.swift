//
//  CachePrayersTimesUseCaseTests.swift
//  PrayersTimesTests
//
//  Created by Salah Amassi on 22/04/2021.
//

import XCTest
import PrayersTimes

class CachePrayersTimesUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_save_requestsCacheDeletion() {
        let (sut, store) = makeSUT()
        let items = [prayersTimes(timeZone: TimeZone(abbreviation: "GMT+3")!), prayersTimes(timeZone: TimeZone(abbreviation: "GMT+3")!)]
        
        sut.save(items) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedPrayersTimes])
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let items = [prayersTimes(timeZone: TimeZone(abbreviation: "GMT+3")!), prayersTimes(timeZone: TimeZone(abbreviation: "GMT+3")!)]
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        sut.save(items) { _ in }
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedPrayersTimes])
    }
    
    func test_save_requestsNewCacheInsertionWithTimestampOnSuccessfulDeletion() {
        let timestamp = Date()
        let items = prayersTimesArray(using: TimeZone(abbreviation: "GMT+3")!)
        let (sut, store) = makeSUT(currentDate: { timestamp })
        
        sut.save(items.models) { _ in }
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedPrayersTimes,
                                                .insert(items.local, timestamp)])
    }
    
    func test_save_failsOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        expect(sut, toCompleteWithError: deletionError) {
            store.completeDeletion(with: deletionError)
        }
    }

    func test_save_failsOnInsertionError() {
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()
        
        expect(sut, toCompleteWithError: insertionError) {
            store.completeDeletionSuccessfully()
            store.completeInsertion(with: insertionError)
        }
    }
    
    func test_save_succeedsOnSuccessfulCacheInsertion() {
        let (sut, store) = makeSUT()
        expect(sut, toCompleteWithError: nil) {
            store.completeDeletionSuccessfully()
            store.completeInsertionSuccessfully()
        }
    }

    func test_save_doesNotDeliverDeletionErrorAfterSUTInstanceHasBeenDeallocated() {
        let store = PrayersTimesStoreSpy()
        var sut: LocalPrayersTimesLoader? = LocalPrayersTimesLoader(store: store, currentDate: Date.init)

        var receivedResults = [LocalPrayersTimesLoader.SaveResult]()
        sut?.save([prayersTimes(timeZone: TimeZone(abbreviation: "GMT+3")!)]) { receivedResults.append($0) }

        sut = nil
        store.completeDeletion(with: anyNSError())

        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    func test_save_doesNotDeliverInsertionErrorAfterSUTInstanceHasBeenDeallocated() {
        let store = PrayersTimesStoreSpy()
        var sut: LocalPrayersTimesLoader? = LocalPrayersTimesLoader(store: store, currentDate: Date.init)

        var receivedResults = [LocalPrayersTimesLoader.SaveResult]()
        sut?.save([prayersTimes(timeZone: TimeZone(abbreviation: "GMT+3")!)]) { receivedResults.append($0) }

        store.completeDeletionSuccessfully()
        sut = nil
        store.completeInsertion(with: anyNSError())

        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    // MARK: - Helpers
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalPrayersTimesLoader, store: PrayersTimesStoreSpy) {
        let store = PrayersTimesStoreSpy()
        let sut = LocalPrayersTimesLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalPrayersTimesLoader, toCompleteWithError expectedError: NSError?, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for save completion")

        var receivedError: LocalPrayersTimesLoader.SaveResult = nil
        sut.save([prayersTimes(timeZone: TimeZone(abbreviation: "GMT+3")!)]) { error in
            receivedError = error
            exp.fulfill()
        }

        action()
        wait(for: [exp], timeout: 1.0)

        XCTAssertEqual((receivedError as NSError?)?.code,
                       expectedError?.code,
                       file: file,
                       line: line)
        XCTAssertEqual((receivedError as NSError?)?.domain,
                       expectedError?.domain,
                       file: file,
                       line: line)
    }
}
