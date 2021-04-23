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
        private let fajr: String
        private let sunrise: String
        private let dhuhr: String
        private let asr: String
        private let sunset: String
        private let maghrib: String
        private let isha: String
        private let imsak: String
        private let midnight: String
        private let date: Date
        
        init(_ prayersTimes: LocalPrayersTimes) {
            self.fajr = prayersTimes.fajr
            self.sunrise = prayersTimes.sunrise
            self.dhuhr = prayersTimes.dhuhr
            self.asr = prayersTimes.asr
            self.sunset = prayersTimes.sunset
            self.maghrib = prayersTimes.maghrib
            self.isha = prayersTimes.isha
            self.imsak = prayersTimes.imsak
            self.midnight = prayersTimes.midnight
            self.date = prayersTimes.date
        }
        
        var local: LocalPrayersTimes {
            .init(fajr: fajr,
                  sunrise: sunrise,
                  dhuhr: dhuhr,
                  asr: asr,
                  sunset: sunset,
                  maghrib: maghrib,
                  isha: isha,
                  imsak: imsak,
                  midnight: midnight,
                  date: date)
        }
    }
}
