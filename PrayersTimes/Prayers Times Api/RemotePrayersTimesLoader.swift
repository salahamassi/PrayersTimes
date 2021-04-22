//
//  RemotePrayersTimesLoader.swift
//  PrayersTimes
//
//  Created by Salah Amassi on 21/04/2021.
//

import Foundation

public final class RemotePrayersTimesLoader: PrayersTimesLoader {
    
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
    
    public typealias Result = PrayersTimesLoader.LoadPrayersTimesResult
    
    public func load(completion: @escaping (RemotePrayersTimesLoader.Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                completion(RemotePrayersTimesLoader.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try PrayersTimesItemMapper.map(data, from: response)
            return .success(items.toModels())
        } catch {
            return .failure(error)
        }
    }
}

private extension Array where Element == RemotePrayersTimes {
    func toModels() -> [PrayersTimes] {
        map { PrayersTimes(fajr: $0.timings.fajr,
                           sunrise: $0.timings.sunrise,
                           dhuhr: $0.timings.dhuhr,
                           asr: $0.timings.asr,
                           sunset: $0.timings.sunset,
                           maghrib: $0.timings.maghrib,
                           isha: $0.timings.isha,
                           imsak: $0.timings.imsak,
                           midnight: $0.timings.midnight,
                           date: Date(timeIntervalSince1970: Double($0.date.timestamp) ?? 0.0)) }
    }
}
