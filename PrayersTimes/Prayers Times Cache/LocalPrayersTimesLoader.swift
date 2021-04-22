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
        store.insert(items, timestamp: currentDate()) { [weak self] error in
            guard self != nil else { return }
            
            completion(error)
        }
    }
}
