//
//  PrayersTimesLoaderTests.swift
//  PrayersTimesTests
//
//  Created by Salah Amassi on 21/04/2021.
//

import Foundation

import XCTest

class PrayersTimesLoader {
    
    let client: HTTPClient
    let url: URL

    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    

    func load() {
        client.get(from: url)
    }
}

protocol HTTPClient {
    func get(from url: URL)
}


class PrayersTimesLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertNil(client.requestedURL)
    }

    func test_load_requestDataFromURL() {
        let (sut, client) = makeSUT()

        sut.load()

        XCTAssertNotNil(client.requestedURL)
    }
    
    // MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: PrayersTimesLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = PrayersTimesLoader(url: url, client: client)
        return (sut, client)
    }
    
    class HTTPClientSpy: HTTPClient {
        func get(from url: URL) {
            requestedURL = url
        }
        
        var requestedURL: URL?
    }
}
