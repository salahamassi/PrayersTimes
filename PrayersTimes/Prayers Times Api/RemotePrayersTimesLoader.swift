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
            let items = try PrayersTimesItemMapper.map(data, from: response).toModels()
            return .success(items)
        } catch {
            return .failure(error)
        }
    }
}

private extension Array where Element == RemotePrayersTimes {
    
    func toModels() throws -> [PrayersTimes] {
        var result = [PrayersTimes]()
        for item in self {
            guard let timestamp = Double(item.date.timestamp) else { throw RemotePrayersTimesLoader.Error.invalidData }
            let date = Date(timeIntervalSince1970: timestamp)
            
            do {
                let prayersTimes = try PrayersTimes(prayers: (fajr: map(item.timings.fajr, using: date),
                                                              sunrise: map(item.timings.sunrise, using: date),
                                                              dhuhr: map(item.timings.dhuhr, using: date),
                                                              asr: map(item.timings.asr, using: date),
                                                              sunset: map(item.timings.sunset, using: date),
                                                              maghrib: map(item.timings.maghrib, using: date),
                                                              isha: map(item.timings.isha, using: date),
                                                              imsak: map(item.timings.imsak, using: date),
                                                              midnight: map(item.timings.midnight, using: date)),
                                                    for: date)
                result.append(prayersTimes)
            } catch {
                throw error
            }
        }
        return result
    }
    
    private func map(_ prayerTime: String, using date: Date) throws -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"

        let splitResult = prayerTime.split(separator: " ")
        var stringPrayerDate = ""
        if let first = splitResult.first, let last = splitResult.last {
            dateFormatter.timeZone = TimeZone(abbreviation: "\(last.dropFirst().dropLast())")
            let fullDateString = dateFormatter.string(from: date)
            
            stringPrayerDate.append(fullDateString)
            stringPrayerDate.append(" \(first):00")
            
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"

            guard let datePrayerTime = dateFormatter.date(from: stringPrayerDate)
            else { throw RemotePrayersTimesLoader.Error.invalidData }
            return datePrayerTime
        } else {
            throw RemotePrayersTimesLoader.Error.invalidData
        }
    }
}
