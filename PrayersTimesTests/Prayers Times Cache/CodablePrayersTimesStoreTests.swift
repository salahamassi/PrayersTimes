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
    
    private let storeURL: URL
    
    init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
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
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        undoStoreSideEffects()
    }
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toRetrieve: .empty)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()

        expect(sut, toRetrieveTwice: .empty)
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
        let sut = makeSUT()
        let prayersTimes = uniqueItems().local
        let timestamp = Date()

        insert((prayersTimes, timestamp), to: sut)

        expect(sut, toRetrieve: .found(prayersTimes: prayersTimes, timestamp: timestamp))
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        let prayersTimes = uniqueItems().local
        let timestamp = Date()
        
        insert((prayersTimes, timestamp), to: sut)
        expect(sut, toRetrieveTwice: .found(prayersTimes: prayersTimes, timestamp: timestamp))
    }
    
    // - MARK: Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> CodablePrayersTimesStore {
        let sut = CodablePrayersTimesStore(storeURL: testSpecificStoreURL())
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func insert(_ cache: (data: [LocalPrayersTimes], timestamp: Date), to sut: CodablePrayersTimesStore) {
        let exp = expectation(description: "Wait for cache insertion")
        sut.insert(cache.data, timestamp: cache.timestamp) { insertionError in
            XCTAssertNil(insertionError, "Expected prayers times to be inserted successfully")
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    private func expect(_ sut: CodablePrayersTimesStore, toRetrieveTwice expectedResult: RetrieveCachedPrayersTimesResult, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }

    private func expect(_ sut: CodablePrayersTimesStore, toRetrieve expectedResult: RetrieveCachedPrayersTimesResult, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.empty, .empty):
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
    
    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
    
    private func testSpecificStoreURL() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(type(of: self)).store")
    }
}
