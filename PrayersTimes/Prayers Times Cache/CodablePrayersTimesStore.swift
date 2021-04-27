//
//  CodablePrayersTimesStore.swift
//  PrayersTimes
//
//  Created by Salah Amassi on 23/04/2021.
//

import Foundation

public class CodablePrayersTimesStore: PrayersTimesStore {
    
    private let queue = DispatchQueue(label: "\(CodablePrayersTimesStore.self)Queue", qos: .userInitiated, attributes: .concurrent)
    private let storeURL: URL
    
    public init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        let storeURL = self.storeURL
        queue.async(flags: .barrier) {
            guard let data = try? Data(contentsOf: storeURL) else {
                return completion(.empty)
            }
            
            do {
                let decoder = JSONDecoder()
                let cache = try decoder.decode(Cache.self, from: data)
                completion(.found(prayersTimes: cache.localPrayersTimes, timestamp: cache.timestamp))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func insert(_ items: [LocalPrayersTimes], timestamp: Date, completion: @escaping InsertionCompletion) {
        let storeURL = self.storeURL
        queue.async {
            do {
                let encoder = JSONEncoder()
                let cache = Cache(data: items.map(CodablePrayersTimes.init), timestamp: timestamp)
                let encoded = try encoder.encode(cache)
                try encoded.write(to: storeURL)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    public func deleteCachedPrayersTimes(completion: @escaping DeletionCompletion) {
        let storeURL = self.storeURL
        queue.async(flags: .barrier) {
            guard FileManager.default.fileExists(atPath: storeURL.path) else {
                return completion(nil)
            }
            do {
                try FileManager.default.removeItem(at: storeURL)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    private struct Cache: Codable {
        let data: [CodablePrayersTimes]
        let timestamp: Date
        
        var localPrayersTimes: [LocalPrayersTimes] {
            data.map(\.local)
        }
    }
    
    private struct CodablePrayersTimes: Codable {
        private let fajr: Date
        private let sunrise: Date
        private let dhuhr: Date
        private let asr: Date
        private let sunset: Date
        private let maghrib: Date
        private let isha: Date
        private let imsak: Date
        private let midnight: Date
        private let date: Date
        
        init(_ prayersTimes: LocalPrayersTimes) {
            self.fajr = prayersTimes[.fajr].date
            self.sunrise = prayersTimes[.sunrise].date
            self.dhuhr = prayersTimes[.dhuhr].date
            self.asr = prayersTimes[.asr].date
            self.sunset = prayersTimes[.sunset].date
            self.maghrib = prayersTimes[.maghrib].date
            self.isha = prayersTimes[.isha].date
            self.imsak = prayersTimes[.imsak].date
            self.midnight = prayersTimes[.midnight].date
            self.date = prayersTimes.day
        }
        
        var local: LocalPrayersTimes {
            .init(prayers: (fajr: fajr,
                            sunrise: sunrise,
                            dhuhr: dhuhr,
                            asr: asr,
                            sunset: sunset,
                            maghrib: maghrib,
                            isha: isha,
                            imsak: imsak,
                            midnight: midnight),
                  for: date)
        }
    }
}
