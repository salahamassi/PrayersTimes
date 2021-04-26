//
//  LoadPrayersTimesFromRemoteUseCaseTests.swift
//  PrayersTimesTests
//
//  Created by Salah Amassi on 21/04/2021.
//

import XCTest
import PrayersTimes

class LoadPrayersTimesFromRemoteUseCaseTests: XCTestCase {
    
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
        
        expect(sut, toCompleteWith: failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        
        for (index, sample) in samples.enumerated() {
            expect(sut,
                   toCompleteWith: failure(.invalidData)) {
                let json = makeItemsJSON([])
                client.complete(withStatusCode: sample, data: json, at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.invalidData)) {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .success([])) {
            let emptyListJSON = makeItemsJSON([])
            client.complete(withStatusCode: 200, data: emptyListJSON)
        }
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        
        let item1 = makeItem(fajr: "05:01 (EEST)",
                             sunrise: "06:31 (EEST)",
                             dhuhr: "12:46 (EEST)",
                             asr: "16:18 (EEST)",
                             sunset: "19:02 (EEST)",
                             maghrib: "19:02 (EEST)",
                             isha: "20:22 (EEST)",
                             imsak: "04:51 (EEST)",
                             midnight: "00:46 (EEST)",
                             day: Date(timeIntervalSince1970: 1617256861))
        
        let item2 = makeItem(fajr: "05:01 (EEST)",
                             sunrise: "06:30 (EEST)",
                             dhuhr: "12:46 (EEST)",
                             asr: "16:18 (EEST)",
                             sunset: "19:02 (EEST)",
                             maghrib: "19:02 (EEST)",
                             isha: "20:22 (EEST)",
                             imsak: "04:50 (EEST)",
                             midnight: "00:46 (EEST)",
                             day: Date(timeIntervalSince1970: 1617343261))
        
        let items = [item1.model, item2.model]
        
        expect(sut, toCompleteWith: .success(items), when: {
            let json = makeItemsJSON([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidDatesJSONItems() {
        let (sut, client) = makeSUT()
        
        let json = [
            "timings": ["Fajr": "invalid Fajr",
                        "Sunrise": "invalid Sunrise",
                        "Dhuhr": "invalid Dhuhr",
                        "Asr": "invalid Asr",
                        "Sunset": "invalid Sunset",
                        "Maghrib": "invalid Maghrib",
                        "Isha": "invalid Isha",
                        "Imsak": "invalid Imsak",
                        "Midnight": "invalid Midnight"],
            "date": ["timestamp": "invalid time stamp"]
        ]
        
        expect(sut, toCompleteWith: failure(.invalidData), when: {
            let json = makeItemsJSON([json])
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        var sut: RemotePrayersTimesLoader? = RemotePrayersTimesLoader(url: url, client: client)
        
        var capturedResults = [RemotePrayersTimesLoader.Result]()
        sut?.load { capturedResults.append($0) }
        
        sut = nil
        client.complete(withStatusCode: 200, data: makeItemsJSON([]))
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    // MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemotePrayersTimesLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemotePrayersTimesLoader(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    private func failure(_ error: RemotePrayersTimesLoader.Error) -> RemotePrayersTimesLoader.Result {
        .failure(error)
    }
    
    private func makeItem(fajr: String, sunrise: String, dhuhr: String, asr: String, sunset: String, maghrib: String, isha: String, imsak: String, midnight: String, day: Date) -> (model: PrayersTimes, json: [String: Any]) {
        let item = PrayersTimes(prayers: (fajr: getDate(from: fajr, using: day),
                                          sunrise: getDate(from: sunrise, using: day),
                                          dhuhr: getDate(from: dhuhr, using: day),
                                          asr: getDate(from: asr, using: day),
                                          sunset: getDate(from: sunset, using: day),
                                          maghrib: getDate(from: maghrib, using: day),
                                          isha: getDate(from: isha, using: day),
                                          imsak: getDate(from: imsak, using: day),
                                          midnight: getDate(from: midnight, using: day)),
                                for: day)
        
        let json = [
            "timings": ["Fajr": fajr,
                        "Sunrise": sunrise,
                        "Dhuhr": dhuhr,
                        "Asr": asr,
                        "Sunset": sunset,
                        "Maghrib": maghrib,
                        "Isha": isha,
                        "Imsak": imsak,
                        "Midnight": midnight],
            "date": ["timestamp": String(item.day.timeIntervalSince1970)]
        ]
        return (item, json)
    }
    
    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json = [
            "code": 200,
            "status": "OK",
            "data": items
        ] as [String : Any]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func expect(_ sut: RemotePrayersTimesLoader, toCompleteWith expectedResult: RemotePrayersTimesLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError as RemotePrayersTimesLoader.Error), .failure(expectedError as RemotePrayersTimesLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    class HTTPClientSpy: HTTPClient {
        
        typealias Result = HTTPClient.Result
        private var messages = [(url: URL, completion: (Result) -> Void)]()
        
        var requestedURLs: [URL] {
            messages.map(\.url)
        }
        
        func get(from url: URL, completion: @escaping (Result) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
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
