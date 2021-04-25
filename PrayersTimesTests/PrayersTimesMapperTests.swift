//
//  PrayersTimesMapperTests.swift
//  PrayersTimesTests
//
//  Created by Salah Amassi on 25/04/2021.
//

import XCTest
import PrayersTimes

class PrayersTimesMapperTests: XCTestCase {
    
    func test_map_throwErrorOnInvalidInputPrayersTimes() {
        let sut = PrayersTimesMapper.self
        
        var receivedError: Error?
        do {
            _ = try sut.map(("invalid prayer time", .dhuhr), using: Date())
        } catch {
            receivedError = error
        }
        
        XCTAssertNotNil(receivedError)
    }

    func test_map_returnOutputPrayerTimesOnValidInputPrayersTimes() {
        let sut = PrayersTimesMapper.self
        let results = try? sut.map((time: "05:01 (EEST)", type: .fajr),
                                   (time: "06:30 (EEST)", type: .sunrise),
                                   (time: "12:46 (EEST)", type: .dhuhr),
                                   (time: "16:18 (EEST)", type: .asr),
                                   (time: "19:02 (EEST)", type: .sunset),
                                   (time: "19:02 (EEST)", type: .maghrib),
                                   (time: "20:22 (EEST)", type: .isha),
                                   (time: "04:50 (EEST)", type: .imsak),
                                   (time: "00:46 (EEST)", type: .midnight),
                                   using: staticDate)
        
        guard let output = results else { return XCTFail("expect results to have a value") }
        
        XCTAssertEqual(output.count, 9)
        
        expect(output[0], mappingCorrectlyAtIndex: 0)
        expect(output[1], mappingCorrectlyAtIndex: 1)
        expect(output[2], mappingCorrectlyAtIndex: 2)
        expect(output[3], mappingCorrectlyAtIndex: 3)
        expect(output[4], mappingCorrectlyAtIndex: 4)
        expect(output[5], mappingCorrectlyAtIndex: 5)
        expect(output[6], mappingCorrectlyAtIndex: 6)
        expect(output[7], mappingCorrectlyAtIndex: 7)
        expect(output[8], mappingCorrectlyAtIndex: 8)
    }
    
    // MARK:- Helper
    private func expect(_ receivedOutputPrayerTime: SwiftyPrayerTime, mappingCorrectlyAtIndex index: Int, file: StaticString = #filePath, line: UInt = #line) {
        let expectedOutputPrayerTime = expectedResult(at:  index)
        XCTAssertEqual(receivedOutputPrayerTime.type, expectedOutputPrayerTime.type, file: file, line: line)
        XCTAssertEqual(receivedOutputPrayerTime.date, expectedOutputPrayerTime.date, file: file, line: line)
    }
    
    private func expectedResult(at index: Int) -> SwiftyPrayerTime {
        [.init(date: Date(timeIntervalSince1970: 1619316060.0), type: .fajr),
         .init(date: Date(timeIntervalSince1970: 1619321400.0), type: .sunrise),
         .init(date: Date(timeIntervalSince1970: 1619343960.0), type: .dhuhr),
         .init(date: Date(timeIntervalSince1970: 1619356680.0), type: .asr),
         .init(date: Date(timeIntervalSince1970: 1619366520.0), type: .sunset),
         .init(date: Date(timeIntervalSince1970: 1619366520.0), type: .maghrib),
         .init(date: Date(timeIntervalSince1970: 1619371320.0), type: .isha),
         .init(date: Date(timeIntervalSince1970: 1619315400.0), type: .imsak),
         .init(date: Date(timeIntervalSince1970: 1619300760.0), type: .midnight)][index]
    }
}
