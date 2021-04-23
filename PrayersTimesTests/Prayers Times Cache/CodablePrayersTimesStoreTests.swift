//
//  CodablePrayersTimesStoreTests.swift
//  PrayersTimesTests
//
//  Created by Salah Amassi on 23/04/2021.
//

import XCTest
import PrayersTimes

class CodablePrayersTimesStore {
    
    private struct Cache: Codable {
        let data: [CodablePrayersTimes]
        let timestamp: Date
        
        var localPrayersTimes: [LocalPrayersTimes] {
            data.map(\.local)
        }
    }
    
    private struct CodablePrayersTimes: Codable {
        private let fajr: String
        private let sunrise: String
        private let dhuhr: String
        private let asr: String
        private let sunset: String
        private let maghrib: String
        private let isha: String
        private let imsak: String
        private let midnight: String
        private let date: Date
        
        init(_ prayersTimes: LocalPrayersTimes) {
            self.fajr = prayersTimes.fajr
            self.sunrise = prayersTimes.sunrise
            self.dhuhr = prayersTimes.dhuhr
            self.asr = prayersTimes.asr
            self.sunset = prayersTimes.sunset
            self.maghrib = prayersTimes.maghrib
            self.isha = prayersTimes.isha
            self.imsak = prayersTimes.imsak
            self.midnight = prayersTimes.midnight
            self.date = prayersTimes.date
        }
        
        var local: LocalPrayersTimes {
            .init(fajr: fajr,
                  sunrise: sunrise,
                  dhuhr: dhuhr,
                  asr: asr,
                  sunset: sunset,
                  maghrib: maghrib,
                  isha: isha,
                  imsak: imsak,
                  midnight: midnight,
                  date: date)
        }
    }
    
    private let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("prayers-times.store")
    
    func retrieve(completion: @escaping PrayersTimesStore.RetrievalCompletion) {
        
        guard let data = try? Data(contentsOf: storeURL) else {
            return completion(.empty)
        }
        
        let decoder = JSONDecoder()
        let cache = try! decoder.decode(Cache.self, from: data)
        completion(.found(prayersTimes: cache.localPrayersTimes, timestamp: cache.timestamp))
    }
    
    func insert(_ items: [LocalPrayersTimes], timestamp: Date, completion: @escaping PrayersTimesStore.InsertionCompletion) {
        let encoder = JSONEncoder()
        let encoded = try! encoder.encode(Cache(data: items.map(CodablePrayersTimes.init), timestamp: timestamp))
        try! encoded.write(to: storeURL)
        completion(nil)
    }
}

class CodablePrayersTimesStoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("prayers-times.store")
        try? FileManager.default.removeItem(at: storeURL)
    }
    
    override func tearDown() {
        super.tearDown()
        
        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("prayers-times.store")
        try? FileManager.default.removeItem(at: storeURL)
    }
    
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
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = CodablePrayersTimesStore()
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { firstResult in
            sut.retrieve { secondResult in
                switch (firstResult, secondResult) {
                case (.empty, .empty):
                    break
                    
                default:
                    XCTFail("Expected retrieving twice from empty cache to deliver same empty result, got \(firstResult) and \(secondResult) instead")
                }
                
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_retrieveAfterInsertingToEmptyCache_deliversInsertedValues() {
        let sut = CodablePrayersTimesStore()
        let prayersTimes = uniqueItems().local
        let timestamp = Date()
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.insert(prayersTimes, timestamp: timestamp) { insertionError in
            XCTAssertNil(insertionError, "Expected prayers times to be inserted successfully")
            
            sut.retrieve { retrieveResult in
                switch retrieveResult {
                case let .found(retrievedPrayersTimes, retrievedTimestamp):
                    XCTAssertEqual(retrievedPrayersTimes, prayersTimes)
                    XCTAssertEqual(retrievedTimestamp, timestamp)
                    
                default:
                    XCTFail("Expected found result with prayers times \(prayersTimes) and timestamp \(timestamp), got \(retrieveResult) instead")
                }
                
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}
