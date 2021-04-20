//
//  PrayersTimesLoaderTests.swift
//  PrayersTimesTests
//
//  Created by Salah Amassi on 21/04/2021.
//

import XCTest
import PrayersTimes

class PrayersTimesLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertNil(client.requestedURL)
    }

    func test_load_requestsDataFromURL() {
        let (sut, client) = makeSUT()

        sut.load()

        XCTAssertNotNil(client.requestedURL)
    }
    
    // MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemotePrayersTimesLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemotePrayersTimesLoader(url: url, client: client)
        return (sut, client)
    }
    
    class HTTPClientSpy: HTTPClient {
        func get(from url: URL) {
            requestedURL = url
        }
        
        var requestedURL: URL?
    }
}
