//
//  PrayersUseCase.swift
//  PrayersTimes
//
//  Created by Salah Amassi on 27/04/2021.
//

import Foundation

public class PrayersUseCase {
    
    public let currentDate: ()-> Date
    public let prayersTimes: [PrayersTimes]
    
    public init(prayersTimes: [PrayersTimes], currentDate: @escaping () -> Date) {
        self.prayersTimes = prayersTimes
        self.currentDate = currentDate
    }
    
    public func getPrayersTimes() -> PrayersTimes? {
        let calendar = Calendar.init(identifier: .gregorian)
        return prayersTimes.first(where: { calendar.isDate($0.day, inSameDayAs: currentDate()) })
    }
    
    public func getNextPrayer() -> Prayers.Prayer? {
        guard let prayersTimes = getPrayersTimes() else { return nil }
        let prayers = [prayersTimes.prayers[.fajr],
                       prayersTimes.prayers[.sunrise],
                       prayersTimes.prayers[.dhuhr],
                       prayersTimes.prayers[.asr],
                       prayersTimes.prayers[.sunset],
                       prayersTimes.prayers[.maghrib],
                       prayersTimes.prayers[.isha],
                       prayersTimes.prayers[.imsak],
                       prayersTimes.prayers[.midnight]]
        return prayers.first(where: { $0.date >  currentDate() && ($0.type != .sunset && $0.type != .sunrise && $0.type != .imsak && $0.type != .midnight) })
    }
}
