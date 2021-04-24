//
//  PrayersTimesMapperTests.swift
//  PrayersTimesTests
//
//  Created by Salah Amassi on 25/04/2021.
//

import XCTest

class PrayersTimesMapper {
    
    enum Error: Swift.Error {
        case invalidPrayerTime(String)
    }
    
    static func map(_ prayersTimes: String ..., using date: Date) throws -> [Date] {
        throw Error.invalidPrayerTime(prayersTimes.first!)
    }
}

class PrayersTimesMapperTests: XCTestCase {

    func test_map_throwErrorOnInvalidPrayersTimes() {
        let sut = PrayersTimesMapper.self
        
        var receivedError: Error?
        do {
            _ = try sut.map("invalid prayer time", using: Date())
        } catch {
            receivedError = error
        }
        
        XCTAssertNotNil(receivedError)
    }
}
