//
//  PrayersTimesLoaderTests.swift
//  PrayersTimesTests
//
//  Created by Salah Amassi on 21/04/2021.
//

import Foundation

import XCTest

class PrayersTimesLoader {
    func load() {
        HTTPClient.shared.requestedURL = URL(string: "https://a-url.com")
    }

}

class HTTPClient {
    static let shared = HTTPClient()

    private init() {}

    var requestedURL: URL?
}



class PrayersTimesLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient.shared
        _ = PrayersTimesLoader()

        XCTAssertNil(client.requestedURL)
    }

    func test_load_requestDataFromURL() {
        let client = HTTPClient.shared
        let sut = PrayersTimesLoader()

        sut.load()

        XCTAssertNotNil(client.requestedURL)
    }
}
