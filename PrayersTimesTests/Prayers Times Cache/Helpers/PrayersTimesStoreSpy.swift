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
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    private var deletionCompletions = [DeletionCompletion]()
    private var insertionCompletions = [InsertionCompletion]()
    
    func insert(_ items: [LocalPrayersTimes], timestamp: Date, completion: @escaping InsertionCompletion) {
        insertionCompletions.append(completion)
        receivedMessages.append(.insert(items, timestamp))
    }

    func deleteCachedPrayersTimes(completion: @escaping DeletionCompletion) {
        deletionCompletions.append(completion)
        receivedMessages.append(.deleteCachedPrayersTimes)
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
}
