//
//  XCTestCase+FailableInsertPrayersTimesStoreSpecs.swift
//  PrayersTimesTests
//
//  Created by Salah Amassi on 23/04/2021.
//

import XCTest
import PrayersTimes

extension FailableInsertPrayersTimesStoreSpecs where Self: XCTestCase {
    
    func assertThatInsertDeliversErrorOnInsertionError(on sut: PrayersTimesStore, file: StaticString = #filePath, line: UInt = #line) {
        let insertionError = insert((prayersTimesArray(using: TimeZone(abbreviation: "GMT+3")!).local, Date()), to: sut)

        XCTAssertNotNil(insertionError, "Expected cache insertion to fail with an error", file: file, line: line)
    }

    func assertThatInsertHasNoSideEffectsOnInsertionError(on sut: PrayersTimesStore, file: StaticString = #filePath, line: UInt = #line) {
        insert((prayersTimesArray(using: TimeZone(abbreviation: "GMT+3")!).local, Date()), to: sut)

        expect(sut, toRetrieve: .empty, file: file, line: line)
    }
}

