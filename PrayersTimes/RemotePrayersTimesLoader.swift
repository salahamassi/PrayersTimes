//
//  RemotePrayersTimesLoader.swift
//  PrayersTimes
//
//  Created by Salah Amassi on 21/04/2021.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Error) -> Void)
}

public final class RemotePrayersTimesLoader {
    
    public let client: HTTPClient
    public let url: URL

    public enum Error: Swift.Error {
        case connectivity
    }

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    

    public func load(completion: @escaping (Error) -> Void = { _ in }) {
        client.get(from: url) { error in
            completion(.connectivity)
        }
    }
}

