//
//  PrayersTimesStoreSpy.swift
//  PrayersTimesTests
//
//  Created by Salah Amassi on 22/04/2021.
//

import Foundation
import PrayersTimes

class PrayersTimesStoreSpy: PrayersTimesStore {
    
    enum ReceivedMessage: Equatable {
        case deleteCachedPrayersTimes
        case insert([LocalPrayersTimes], Date)
        case retrieve
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    private var deletionCompletions = [DeletionCompletion]()
    private var insertionCompletions = [InsertionCompletion]()
    private var retrievalCompletions = [RetrievalCompletion]()
    
    func insert(_ data: [LocalPrayersTimes], timestamp: Date, completion: @escaping InsertionCompletion) {
        insertionCompletions.append(completion)
        receivedMessages.append(.insert(data, timestamp))
    }
    
    func deleteCachedPrayersTimes(completion: @escaping DeletionCompletion) {
        deletionCompletions.append(completion)
        receivedMessages.append(.deleteCachedPrayersTimes)
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        retrievalCompletions.append(completion)
        receivedMessages.append(.retrieve)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](nil)
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](error)
    }
    
    func completeRetrieval(with prayersTimes: [LocalPrayersTimes], timestamp: Date, at index: Int = 0) {
        retrievalCompletions[index](.found(prayersTimes: prayersTimes, timestamp: timestamp))
    }

    func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retrievalCompletions[index](.empty)
    }

    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
}
