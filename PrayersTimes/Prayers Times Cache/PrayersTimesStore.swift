//
//  PrayersTimesStore.swift
//  PrayersTimes
//
//  Created by Salah Amassi on 22/04/2021.
//

import Foundation

public enum RetrieveCachedPrayersTimesResult {
    case empty
    case found(prayersTimes: [LocalPrayersTimes], timestamp: Date)
    case failure(Error)
}

public protocol PrayersTimesStore {

    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (RetrieveCachedPrayersTimesResult) -> Void

    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func insert(_ data: [LocalPrayersTimes], timestamp: Date, completion: @escaping InsertionCompletion)
    
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func deleteCachedPrayersTimes(completion: @escaping DeletionCompletion)
    
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func retrieve(completion: @escaping RetrievalCompletion)
}
