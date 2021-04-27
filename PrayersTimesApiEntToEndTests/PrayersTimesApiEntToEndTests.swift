//
//  PrayersTimesApiEntToEndTests.swift
//  PrayersTimesApiEntToEndTests
//
//  Created by Salah Amassi on 21/04/2021.
//

import XCTest
import PrayersTimes

class PrayersTimesApiEntToEndTests: XCTestCase {
    
    func test_endToEndTestServerGETPrayerTimesResult_matchesFixedServerURL() {        
        switch getPrayerTimesResult() {
        case let .success(items)?:
            XCTAssertEqual(items.count, 30, "Expected 30 items.")
            XCTAssertEqual(items[0], expectedItem(at: 0))
        case let .failure(error)?:
            XCTFail("Expected successful prayers times result, got \(error) instead")
        default:
            XCTFail("Expected successful prayers times, got no result instead")
        }
    }
    
    private func getPrayerTimesResult(file: StaticString = #filePath, line: UInt = #line) -> RemotePrayersTimesLoader.Result? {
        let serverURL = URL(string: "http://api.aladhan.com/v1/calendar?latitude=31.524019&longitude=34.445422&method=5&month=04&year=1437")!
        let client = URLSessionHTTPClient()
        let loader = RemotePrayersTimesLoader(url: serverURL, client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)

        let exp = expectation(description: "Wait for load completion")

        var receivedResult: RemotePrayersTimesLoader.Result?
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 7.0)

        return receivedResult
    }

    private func expectedItem(at index: Int) -> PrayersTimes {
        .init(prayers: (fajr: getDate(from: fajr(at: 0), using: date(at: 0)),
                            sunrise: getDate(from: sunrise(at: 0), using: date(at: 0)),
                            dhuhr: getDate(from: dhuhr(at: 0), using: date(at: 0)),
                            asr: getDate(from: asr(at: 0), using: date(at: 0)),
                            sunset: getDate(from: sunset(at: 0), using: date(at: 0)),
                            maghrib: getDate(from: maghrib(at: 0), using: date(at: 0)),
                            isha: getDate(from: isha(at: 0), using: date(at: 0)),
                            imsak: getDate(from: imsak(at: 0), using: date(at: 0)),
                            midnight: getDate(from: midnight(at: 0), using: date(at: 0))),
                            for: date(at: 0))
    }
    
    private func fajr(at index: Int) -> String {
        ["04:20 (LMT)"][index]
    }
    
    private func sunrise(at index: Int) -> String {
        ["05:49 (LMT)"][index]
    }
    
    private func dhuhr(at index: Int) -> String {
        ["12:04 (LMT)"][index]
    }
    
    private func asr(at index: Int) -> String {
        ["15:36 (LMT)"][index]
    }
    
    private func sunset(at index: Int) -> String {
        ["18:19 (LMT)"][index]
    }
    
    private func maghrib(at index: Int) -> String {
        ["18:19 (LMT)"][index]
    }
    
    private func isha(at index: Int) -> String {
        ["19:39 (LMT)"][index]
    }
    
    private func imsak(at index: Int) -> String {
        ["04:10 (LMT)"][index]
    }
    
    private func midnight(at index: Int) -> String {
        ["00:04 (LMT)"][index]
    }
    
    private func date(at index: Int) -> Date {
        [Date(timeIntervalSince1970: -16812033411)][index]
    }
}
