//
//  PrayersTimesLoader.swift
//  PrayersTimes
//
//  Created by Salah Amassi on 20/04/2021.
//

import Foundation

public protocol PrayersTimesLoader {
    typealias LoadPrayersTimesResult = Result<[PrayersTimes], Error>
    func load(completion: @escaping (LoadPrayersTimesResult) -> Void)
}
