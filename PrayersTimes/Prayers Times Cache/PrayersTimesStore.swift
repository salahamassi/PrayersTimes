//
//  PrayersTimesStore.swift
//  PrayersTimes
//
//  Created by Salah Amassi on 22/04/2021.
//

import Foundation

public protocol PrayersTimesStore {
    
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (Error?) -> Void

    func insert(_ items: [LocalPrayersTimes], timestamp: Date, completion: @escaping InsertionCompletion)
    
    func deleteCachedPrayersTimes(completion: @escaping DeletionCompletion)
    
    func retrieve(completion: @escaping RetrievalCompletion)
}
