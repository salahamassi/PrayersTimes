//
//  CachePrayersTimesUseCaseTests.swift
//  PrayersTimesTests
//
//  Created by Salah Amassi on 22/04/2021.
//

import XCTest

class LocalPrayersTimesLoader {
    init(store: PrayersTimesStore) {

    }
}

class PrayersTimesStore {
    var deleteCachedPrayersTimesCallCount = 0
}

class CachePrayersTimesUseCaseTests: XCTestCase {
    
    func test_init_doesNotDeleteCacheUponCreation() {
        let store = PrayersTimesStore()
        _ = LocalPrayersTimesLoader(store: store)

        XCTAssertEqual(store.deleteCachedPrayersTimesCallCount, 0)
    }
}
