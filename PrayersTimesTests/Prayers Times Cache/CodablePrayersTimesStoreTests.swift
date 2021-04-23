//
//  CodablePrayersTimesStoreTests.swift
//  PrayersTimesTests
//
//  Created by Salah Amassi on 23/04/2021.
//

import XCTest
import PrayersTimes

class CodablePrayersTimesStore {
    
    func retrieve(completion: @escaping PrayersTimesStore.RetrievalCompletion) {
        completion(.empty)
    }
}

class CodablePrayersTimesStoreTests: XCTestCase {

    func test_retrieve_deliversEmptyOnEmptyCache() {
        
        let sut = CodablePrayersTimesStore()
        let exp = expectation(description: "Wait for cache retrieval")

        sut.retrieve { result in
            switch result {
            case .empty:
                break

            default:
                XCTFail("Expected empty result, got \(result) instead")
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }
}
