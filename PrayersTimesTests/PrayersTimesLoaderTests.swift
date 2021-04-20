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
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        
        for (index, sample) in samples.enumerated() {
            expect(sut, toCompleteWith: .failure(.invalidData)) {
                client.complete(withStatusCode: sample, at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.invalidData)) {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }

    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .success([])) {
            let emptyListJSON = Data("{\"code\": 200,\"status\":\"OK\",\"data\": []}".utf8)
            client.complete(withStatusCode: 200, data: emptyListJSON)
        }
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()

        let item1 = PrayerTime(fajr: "05:01 (EEST)",
                               sunrise: "06:31 (EEST)",
                               dhuhr: "12:46 (EEST)",
                               asr: "16:18 (EEST)",
                               sunset: "19:02 (EEST)",
                               maghrib: "19:02 (EEST)",
                               isha: "20:22 (EEST)",
                               imsak: "04:51 (EEST)",
                               midnight: "00:46 (EEST)",
                               date: Date(timeIntervalSince1970: 1617256861))
        
        let item1JSON = [
            "timings": ["Fajr": item1.fajr,
                        "Sunrise": item1.sunrise,
                        "Dhuhr": item1.dhuhr,
                        "Asr": item1.asr,
                        "Sunset": item1.sunset,
                        "Maghrib": item1.maghrib,
                        "Isha": item1.isha,
                        "Imsak": item1.imsak,
                        "Midnight": item1.midnight],
            "date": ["timestamp": String(item1.date.timeIntervalSince1970)]
        ]
        let item2 = PrayerTime(fajr: "05:01 (EEST)",
                               sunrise: "06:30 (EEST)",
                               dhuhr: "12:46 (EEST)",
                               asr: "16:18 (EEST)",
                               sunset: "19:02 (EEST)",
                               maghrib: "19:02 (EEST)",
                               isha: "20:22 (EEST)",
                               imsak: "04:50 (EEST)",
                               midnight: "00:46 (EEST)",
                               date: Date(timeIntervalSince1970: 1617343261))
        
        let item2JSON = [
            "timings": ["Fajr": item2.fajr,
                        "Sunrise": item2.sunrise,
                        "Dhuhr": item2.dhuhr,
                        "Asr": item2.asr,
                        "Sunset": item2.sunset,
                        "Maghrib": item2.maghrib,
                        "Isha": item2.isha,
                        "Imsak": item2.imsak,
                        "Midnight": item2.midnight],
            "date": ["timestamp": String(item2.date.timeIntervalSince1970)]
        ]

        let itemsJSON = [
            "code": 200,
            "status": "OK",
            "data": [item1JSON, item2JSON]
        ] as [String : Any]

        expect(sut, toCompleteWith: .success([item1, item2]), when: {
            let json = try! JSONSerialization.data(withJSONObject: itemsJSON)
            client.complete(withStatusCode: 200, data: json)
        })
    }
    // MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemotePrayersTimesLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemotePrayersTimesLoader(url: url, client: client)
        return (sut, client)
    }
    
    private func expect(_ sut: RemotePrayersTimesLoader, toCompleteWith result: RemotePrayersTimesLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        var capturedResults = [RemotePrayersTimesLoader.Result]()
        sut.load { capturedResults.append($0) }

        action()
        
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    class HTTPClientSpy: HTTPClient {
        
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        var requestedURLs: [URL] {
            messages.map(\.url)
        }
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!
            messages[index].completion(.success((data, response)))
        }
    }
}
