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
    
    init(client: HTTPClient) {
        self.client = client
    }
    

    func load() {
        client.get(from: URL(string: "https://a-url.com")!)
    }
}


protocol HTTPClient {
    func get(from url: URL)
}


class HTTPClientSpy: HTTPClient {
    func get(from url: URL) {
        requestedURL = url
    }
    
    var requestedURL: URL?
}


class PrayersTimesLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        _ = PrayersTimesLoader(client: client)

        XCTAssertNil(client.requestedURL)
    }

    func test_load_requestDataFromURL() {
        let client = HTTPClientSpy()
        let sut = PrayersTimesLoader(client: client)

        sut.load()

        XCTAssertNotNil(client.requestedURL)
    }
}
