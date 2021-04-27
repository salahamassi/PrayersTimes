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
    
    public init(store: PrayersTimesStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

extension LocalPrayersTimesLoader {
    
    public typealias SaveResult = Error?
    
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
}

extension LocalPrayersTimesLoader: PrayersTimesLoader {
    
    public typealias LoadResult = PrayersTimesLoader.LoadPrayersTimesResult
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .found(prayersTimes, timestamp) where PrayersTimesCachePolicy.validate(timestamp, against: self.currentDate()):
                completion(.success(prayersTimes.toModels()))
            case .empty,.found:
                completion(.success([]))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

extension LocalPrayersTimesLoader {
    
    public func validateCache() {
        store.retrieve { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .found(_, timestamp) where !PrayersTimesCachePolicy.validate(timestamp, against: self.currentDate()):
                self.store.deleteCachedPrayersTimes { _ in }
            case .failure:
                self.store.deleteCachedPrayersTimes { _ in }
            default: break
            }
        }
    }
}

private extension Array where Element == PrayersTimes {
    func toLocal() -> [LocalPrayersTimes] {
        map { LocalPrayersTimes(prayers: (fajr: $0[.fajr].date,
                                          sunrise: $0[.sunrise].date,
                                          dhuhr: $0[.dhuhr].date,
                                          asr: $0[.asr].date,
                                          sunset: $0[.sunset].date,
                                          maghrib: $0[.maghrib].date,
                                          isha: $0[.isha].date,
                                          imsak: $0[.imsak].date,
                                          midnight: $0[.midnight].date), for: $0.day) }
    }
}

private extension Array where Element == LocalPrayersTimes {
    func toModels() -> [PrayersTimes] {
        map { PrayersTimes(prayers: (fajr: $0[.fajr].date,
                                     sunrise: $0[.sunrise].date,
                                     dhuhr: $0[.dhuhr].date,
                                     asr: $0[.asr].date,
                                     sunset: $0[.sunset].date,
                                     maghrib: $0[.maghrib].date,
                                     isha: $0[.isha].date,
                                     imsak: $0[.imsak].date,
                                     midnight: $0[.midnight].date), for: $0.day) }
    }
}

