//
//  XCTestCase+FailableRetrievePrayersTimesStoreSpecs.swift
//  PrayersTimesTests
//
//  Created by Salah Amassi on 23/04/2021.
//

import XCTest
import PrayersTimes

extension FailableRetrievePrayersTimesStoreSpecs where Self: XCTestCase {
    
    func assertThatRetrieveDeliversFailureOnRetrievalError(on sut: PrayersTimesStore, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieve: .failure(anyNSError()), file: file, line: line)
    }

    func assertThatRetrieveHasNoSideEffectsOnFailure(on sut: PrayersTimesStore, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieveTwice: .failure(anyNSError()), file: file, line: line)
    }
}
