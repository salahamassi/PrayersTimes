//
//  CachePrayersTimesUseCaseTests.swift
//  PrayersTimesTests
//
//  Created by Salah Amassi on 22/04/2021.
//

import XCTest
import PrayersTimes

class LocalPrayersTimesLoader {
    
    private let store: PrayersTimesStore
    
    init(store: PrayersTimesStore) {
        self.store = store
    }
    
    func save(_ items: [PrayersTimes]) {
        store.deleteCachedPrayersTimes()
    }
}

class PrayersTimesStore {
    var deleteCachedPrayersTimesCallCount = 0
    
    func deleteCachedPrayersTimes() {
        deleteCachedPrayersTimesCallCount += 1
    }
}

class CachePrayersTimesUseCaseTests: XCTestCase {
    
    func test_init_doesNotDeleteCacheUponCreation() {
        let store = PrayersTimesStore()
        _ = LocalPrayersTimesLoader(store: store)
        
        XCTAssertEqual(store.deleteCachedPrayersTimesCallCount, 0)
    }
    
    func test_save_requestsCacheDeletion() {
        let store = PrayersTimesStore()
        let sut = LocalPrayersTimesLoader(store: store)
        let items = [uniqueItem(), uniqueItem()]
        
        sut.save(items)
        
        XCTAssertEqual(store.deleteCachedPrayersTimesCallCount, 1)
    }
    
    // MARK: - Helpers
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
}
