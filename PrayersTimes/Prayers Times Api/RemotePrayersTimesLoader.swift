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
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let fullDateString = dateFormatter.string(from: date)
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
            
            do {
                let prayersTimes = try PrayersTimes(prayers: (fajr: map(item.timings.fajr, dateFormatter, fullDateString),
                                                              sunrise: map(item.timings.sunrise, dateFormatter, fullDateString),
                                                              dhuhr: map(item.timings.dhuhr, dateFormatter, fullDateString),
                                                              asr: map(item.timings.asr, dateFormatter, fullDateString),
                                                              sunset: map(item.timings.sunset, dateFormatter, fullDateString),
                                                              maghrib: map(item.timings.maghrib, dateFormatter, fullDateString),
                                                              isha: map(item.timings.isha, dateFormatter, fullDateString),
                                                              imsak: map(item.timings.imsak, dateFormatter, fullDateString),
                                                              midnight: map(item.timings.midnight, dateFormatter, fullDateString)),
                                                    for: date)
                result.append(prayersTimes)
            } catch {
                throw error
            }
        }
        return result
    }
    
    private func map(_ prayerTime: String, _ dateFormatter: DateFormatter, _ fullDateString: String) throws -> Date {
        let splitResult = prayerTime.split(separator: " ")
        var stringPrayerDate = ""
        if let first = splitResult.first, let last = splitResult.last {
            dateFormatter.timeZone = TimeZone(abbreviation: String(last))
            stringPrayerDate.append(fullDateString)
            stringPrayerDate.append(" \(first):00")
            guard let datePrayerTime = dateFormatter.date(from: stringPrayerDate)
            else { throw RemotePrayersTimesLoader.Error.invalidData }
            return datePrayerTime
        } else {
            throw RemotePrayersTimesLoader.Error.invalidData
        }
    }
}
