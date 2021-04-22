//
//  LocalPrayersTimesLoader.swift
//  PrayersTimes
//
//  Created by Salah Amassi on 22/04/2021.
//

import Foundation

public final class LocalPrayersTimesLoader {
    
    private let store: PrayersTimesStore
    private let currentDate: () -> Date
    
    public typealias SaveResult = Error?
    public typealias LoadResult = PrayersTimesLoader.LoadPrayersTimesResult
    
    public init(store: PrayersTimesStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func save(_ items: [PrayersTimes], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedPrayersTimes { [weak self] error in
            guard let self = self else { return }
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                self.cache(items, with: completion)
            }
        }
    }
    
    private func cache(_ items: [PrayersTimes], with completion: @escaping (SaveResult) -> Void) {
        store.insert(items.toLocal(), timestamp: currentDate()) { [weak self] error in
            guard self != nil else { return }
            
            completion(error)
        }
    }
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [unowned self] result in
            switch result {
            case let .found(prayersTimes, timestamp) where self.validate(timestamp):
                completion(.success(prayersTimes.toModels()))
            case .found, .empty:
                completion(.success([]))
            case let .failure(error):
                self.store.deleteCachedPrayersTimes { _ in }
                completion(.failure(error))
            }
        }
    }
    
    private func validate(_ timestamp: Date) -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.isDate(currentDate(), equalTo: timestamp, toGranularity: .month)
    }
}

private extension Array where Element == PrayersTimes {
    func toLocal() -> [LocalPrayersTimes] {
        map { LocalPrayersTimes(fajr: $0.fajr,
                                sunrise: $0.sunrise,
                                dhuhr: $0.dhuhr,
                                asr: $0.asr,
                                sunset: $0.sunset,
                                maghrib: $0.maghrib,
                                isha: $0.isha,
                                imsak: $0.imsak,
                                midnight: $0.midnight,
                                date: $0.date)
        }
    }
}

private extension Array where Element == LocalPrayersTimes {
    func toModels() -> [PrayersTimes] {
        map { PrayersTimes(fajr: $0.fajr,
                                sunrise: $0.sunrise,
                                dhuhr: $0.dhuhr,
                                asr: $0.asr,
                                sunset: $0.sunset,
                                maghrib: $0.maghrib,
                                isha: $0.isha,
                                imsak: $0.imsak,
                                midnight: $0.midnight,
                                date: $0.date) }
    }
}

