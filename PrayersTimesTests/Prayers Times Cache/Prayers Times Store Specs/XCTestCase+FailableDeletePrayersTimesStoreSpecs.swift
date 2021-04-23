//
//  XCTestCase+FailableDeletePrayersTimesStoreSpecs.swift
//  PrayersTimesTests
//
//  Created by Salah Amassi on 23/04/2021.
//

import XCTest
import PrayersTimes


extension FailableDeletePrayersTimesStoreSpecs where Self: XCTestCase {
    
    func assertThatDeleteDeliversErrorOnDeletionError(on sut: PrayersTimesStore, file: StaticString = #filePath, line: UInt = #line) {
        let deletionError = deleteCache(from: sut)

        XCTAssertNotNil(deletionError, "Expected cache deletion to fail", file: file, line: line)
    }

    func assertThatDeleteHasNoSideEffectsOnDeletionError(on sut: PrayersTimesStore, file: StaticString = #filePath, line: UInt = #line) {
        deleteCache(from: sut)

        expect(sut, toRetrieve: .empty, file: file, line: line)
    }
}
