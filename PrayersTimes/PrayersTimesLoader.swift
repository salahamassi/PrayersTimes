//
//  PrayersTimesLoader.swift
//  PrayersTimes
//
//  Created by Salah Amassi on 20/04/2021.
//

import Foundation

protocol PrayersTimesLoader {
    typealias LoadPrayersTimesResult = Result<[PrayerTime], Error>
    func load(completion: @escaping (LoadPrayersTimesResult) -> Void)
}
