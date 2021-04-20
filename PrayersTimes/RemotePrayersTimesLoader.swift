//
//  RemotePrayersTimesLoader.swift
//  PrayersTimes
//
//  Created by Salah Amassi on 21/04/2021.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL)
}

public final class RemotePrayersTimesLoader {
    
    public let client: HTTPClient
    public let url: URL

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    

    public func load() {
        client.get(from: url)
    }
}

