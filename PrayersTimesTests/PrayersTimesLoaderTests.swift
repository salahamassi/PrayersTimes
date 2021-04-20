//
//  PrayersTimesLoaderTests.swift
//  PrayersTimesTests
//
//  Created by Salah Amassi on 21/04/2021.
//

import Foundation

import XCTest

class PrayersTimesLoader {

}

class HTTPClient {
    var requestedURL: URL?
}

class PrayersTimesLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient()
        _ = PrayersTimesLoader()

        XCTAssertNil(client.requestedURL)
    }

}
