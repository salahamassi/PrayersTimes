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
        let prayers = [prayersTimes[.fajr],
                       prayersTimes[.dhuhr],
                       prayersTimes[.asr],
                       prayersTimes[.maghrib],
                       prayersTimes[.isha]]
        return prayers.first(where: { $0.date > currentDate() })
    }
    
    public func calculateRemainingTime(to prayer: Prayers.Prayer) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.dateComponents([.second], from: currentDate(), to: prayer.date).second ?? .zero
    }
}
