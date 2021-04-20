//
//  RemotePrayersTimesLoader.swift
//  PrayersTimes
//
//  Created by Salah Amassi on 21/04/2021.
//

import Foundation


public protocol HTTPClient {
    typealias HTTPClientResult = Result<(Data, HTTPURLResponse), Error>
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public final class RemotePrayersTimesLoader {
    
    public let client: HTTPClient
    public let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public typealias Result = Swift.Result<[PrayerTime], Error>

    public func load(completion: @escaping (RemotePrayersTimesLoader.Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success((data, _)):
                if let _ = try? JSONSerialization.jsonObject(with: data) {
                    completion(.success([]))
                } else {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}

