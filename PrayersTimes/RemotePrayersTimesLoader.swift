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
            case let .success((data, response)):
                if response.statusCode == 200,
                   let root = try? JSONDecoder().decode(Root.self, from: data) {
                    completion(.success(root.prayersTimes))
                } else {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
    
    private struct Root: Decodable {
        
        let code: Int
        let status: String
        let data: [RemotePrayerTime]
        
        var prayersTimes: [PrayerTime] {
            data.map(\.prayerTime)
        }
        
        struct RemotePrayerTime: Decodable {
            let timings: Timings
            let date: PrayerTimeDate
            
            var prayerTime: PrayerTime {
                .init(fajr: timings.fajr,
                      sunrise: timings.sunrise,
                      dhuhr: timings.dhuhr,
                      asr: timings.asr,
                      sunset: timings.sunset,
                      maghrib: timings.maghrib,
                      isha: timings.isha,
                      imsak: timings.imsak,
                      midnight: timings.midnight,
                      date: Date(timeIntervalSince1970: Double(date.timestamp) ?? 0.0))
            }
      
            struct Timings: Decodable {
                
                let fajr: String
                let sunrise: String
                let dhuhr: String
                let asr: String
                let sunset: String
                let maghrib: String
                let isha: String
                let imsak: String
                let midnight: String
                
                private enum CodingKeys: String, CodingKey {
                    case fajr = "Fajr"
                    case sunrise = "Sunrise"
                    case dhuhr = "Dhuhr"
                    case asr = "Asr"
                    case sunset = "Sunset"
                    case maghrib = "Maghrib"
                    case isha = "Isha"
                    case imsak = "Imsak"
                    case midnight = "Midnight"
                }
            }
            
            struct PrayerTimeDate: Codable {
                let timestamp: String
            }
        }
    }
}
