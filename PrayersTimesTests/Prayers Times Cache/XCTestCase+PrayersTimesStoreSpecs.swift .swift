//
//  XCTestCase+PrayersTimesStoreSpecs.swift .swift
//  PrayersTimesTests
//
//  Created by Salah Amassi on 23/04/2021.
//

import XCTest
import PrayersTimes

extension PrayersTimesStoreSpecs where Self: XCTestCase {

    func assertThatRetrieveDeliversEmptyOnEmptyCache(on sut: PrayersTimesStore, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieve: .empty, file: file, line: line)
    }

    func assertThatRetrieveHasNoSideEffectsOnEmptyCache(on sut: PrayersTimesStore, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieveTwice: .empty, file: file, line: line)
    }

    func assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on sut: PrayersTimesStore, file: StaticString = #filePath, line: UInt = #line) {
        let prayersTimes = uniqueItems().local
        let timestamp = Date()

        insert((prayersTimes, timestamp), to: sut)

        expect(sut, toRetrieve: .found(prayersTimes: prayersTimes, timestamp: timestamp), file: file, line: line)
    }

    func assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on sut: PrayersTimesStore, file: StaticString = #filePath, line: UInt = #line) {
        let prayersTimes = uniqueItems().local
        let timestamp = Date()

        insert((prayersTimes, timestamp), to: sut)

        expect(sut, toRetrieveTwice: .found(prayersTimes: prayersTimes, timestamp: timestamp), file: file, line: line)
    }

    func assertThatInsertDeliversNoErrorOnEmptyCache(on sut: PrayersTimesStore, file: StaticString = #filePath, line: UInt = #line) {
        let insertionError = insert((uniqueItems().local, Date()), to: sut)

        XCTAssertNil(insertionError, "Expected to insert cache successfully", file: file, line: line)
    }

    func assertThatInsertDeliversNoErrorOnNonEmptyCache(on sut: PrayersTimesStore, file: StaticString = #filePath, line: UInt = #line) {
        insert((uniqueItems().local, Date()), to: sut)

        let insertionError = insert((uniqueItems().local, Date()), to: sut)

        XCTAssertNil(insertionError, "Expected to override cache successfully", file: file, line: line)
    }

    func assertThatInsertOverridesPreviouslyInsertedCacheValues(on sut: PrayersTimesStore, file: StaticString = #filePath, line: UInt = #line) {
        insert((uniqueItems().local, Date()), to: sut)

        let latestPrayersTimes = uniqueItems().local
        let latestTimestamp = Date()
        insert((latestPrayersTimes, latestTimestamp), to: sut)

        expect(sut, toRetrieve: .found(prayersTimes: latestPrayersTimes, timestamp: latestTimestamp), file: file, line: line)
    }

    func assertThatDeleteDeliversNoErrorOnEmptyCache(on sut: PrayersTimesStore, file: StaticString = #filePath, line: UInt = #line) {
        let deletionError = deleteCache(from: sut)

        XCTAssertNil(deletionError, "Expected empty cache deletion to succeed", file: file, line: line)
    }

    func assertThatDeleteHasNoSideEffectsOnEmptyCache(on sut: PrayersTimesStore, file: StaticString = #filePath, line: UInt = #line) {
        deleteCache(from: sut)

        expect(sut, toRetrieve: .empty, file: file, line: line)
    }

    func assertThatDeleteDeliversNoErrorOnNonEmptyCache(on sut: PrayersTimesStore, file: StaticString = #filePath, line: UInt = #line) {
        insert((uniqueItems().local, Date()), to: sut)

        let deletionError = deleteCache(from: sut)

        XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed", file: file, line: line)
    }

    func assertThatDeleteEmptiesPreviouslyInsertedCache(on sut: PrayersTimesStore, file: StaticString = #filePath, line: UInt = #line) {
        insert((uniqueItems().local, Date()), to: sut)

        deleteCache(from: sut)

        expect(sut, toRetrieve: .empty, file: file, line: line)
    }

    func assertThatSideEffectsRunSerially(on sut: PrayersTimesStore, file: StaticString = #filePath, line: UInt = #line) {
        var completedOperationsInOrder = [XCTestExpectation]()

        let op1 = expectation(description: "Operation 1")
        sut.insert(uniqueItems().local, timestamp: Date()) { _ in
            completedOperationsInOrder.append(op1)
            op1.fulfill()
        }
        
        let op2 = expectation(description: "Operation 2")
        sut.deleteCachedPrayersTimes { _ in
            completedOperationsInOrder.append(op2)
            op2.fulfill()
        }

        let op3 = expectation(description: "Operation 3")
        sut.insert(uniqueItems().local, timestamp: Date()) { _ in
            completedOperationsInOrder.append(op3)
            op3.fulfill()
        }

        waitForExpectations(timeout: 5.0)

        XCTAssertEqual(completedOperationsInOrder, [op1, op2, op3], "Expected side-effects to run serially but operations finished in the wrong order", file: file, line: line)
    }

}

extension PrayersTimesStoreSpecs where Self: XCTestCase {
    
    @discardableResult
    func insert(_ cache: (data: [LocalPrayersTimes], timestamp: Date), to sut: PrayersTimesStore) -> Error? {
        let exp = expectation(description: "Wait for cache insertion")
        var insertionError: Error?
        sut.insert(cache.data, timestamp: cache.timestamp) { receivedInsertionError in
            insertionError = receivedInsertionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return insertionError
    }
    
    @discardableResult
    func deleteCache(from sut: PrayersTimesStore) -> Error? {
        let exp = expectation(description: "Wait for cache deletion")
        var deletionError: Error?
        sut.deleteCachedPrayersTimes { receivedDeletionError in
            deletionError = receivedDeletionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return deletionError
    }
    
    func expect(_ sut: PrayersTimesStore, toRetrieveTwice expectedResult: RetrieveCachedPrayersTimesResult, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    func expect(_ sut: PrayersTimesStore, toRetrieve expectedResult: RetrieveCachedPrayersTimesResult, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.empty, .empty),
                 (.failure, .failure):
                break
                
            case let (.found(expectedPrayersTimes, expectedTimestamp),
                      .found(retrievedPrayersTimes, retrievedTimestamp)):
                XCTAssertEqual(retrievedPrayersTimes, expectedPrayersTimes, file: file, line: line)
                XCTAssertEqual(retrievedTimestamp, expectedTimestamp, file: file, line: line)
                
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}
