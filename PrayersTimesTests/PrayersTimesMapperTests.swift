//
//  PrayersTimesMapperTests.swift
//  PrayersTimesTests
//
//  Created by Salah Amassi on 25/04/2021.
//

import XCTest

class PrayersTimesMapper {
    
    enum Error: Swift.Error {
        case invalidPrayerTime(Input)
    }
    
    enum PrayersType {
        case fajr
        case sunrise
        case dhuhr
        case asr
        case sunset
        case maghrib
        case isha
        case imsak
        case midnight
    }
    
    typealias Input = (time: String, type: PrayersType)
    typealias Output = (date: Date, type: PrayersType)
    
    static func map(_ prayersTimes: Input ..., using date: Date) throws -> [Output] {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let fullDateString = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        var results = [Output]()
        for prayerTime in prayersTimes {
            let splitResult = prayerTime.time.split(separator: " ")
            var stringPrayerDate = ""
            if let first = splitResult.first, let last = splitResult.last {
                dateFormatter.timeZone = TimeZone(abbreviation: String(last))
                stringPrayerDate.append(fullDateString)
                stringPrayerDate.append(" \(first):00")
                guard let datePrayerTime = dateFormatter.date(from: stringPrayerDate)
                else { throw  Error.invalidPrayerTime(prayerTime) }
                results.append((date: datePrayerTime, type: prayerTime.type))
            } else {
                throw Error.invalidPrayerTime(prayerTime)
            }
        }
        print(results.map(\.date.timeIntervalSince1970), "salah")
        return results
    }
}

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
                                   using: Date())
        
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
    }
    
    // MARK:- Helper
    private func expect(_ receivedOutputPrayerTime: PrayersTimesMapper.Output, mappingCorrectlyAtIndex index: Int, file: StaticString = #filePath, line: UInt = #line) {
        let expectedOutputPrayerTime = expectedResult(at:  index)
        XCTAssertEqual(receivedOutputPrayerTime.type, expectedOutputPrayerTime.type, file: file, line: line)
        XCTAssertEqual(receivedOutputPrayerTime.date, expectedOutputPrayerTime.date, file: file, line: line)
    }
    
    private func expectedResult(at index: Int) -> PrayersTimesMapper.Output {
        [(date: Date(timeIntervalSince1970: 1619316060.0), type: .fajr),
         (date: Date(timeIntervalSince1970: 1619321400.0), type: .sunrise),
         (date: Date(timeIntervalSince1970: 1619343960.0), type: .dhuhr),
         (date: Date(timeIntervalSince1970: 1619356680.0), type: .asr),
         (date: Date(timeIntervalSince1970: 1619366520.0), type: .sunset),
         (date: Date(timeIntervalSince1970: 1619366520.0), type: .maghrib),
         (date: Date(timeIntervalSince1970: 1619371320.0), type: .isha),
         (date: Date(timeIntervalSince1970: 1619315400.0), type: .imsak),
         (date: Date(timeIntervalSince1970: 1619300760.0), type: .midnight)][index]
    }
}
