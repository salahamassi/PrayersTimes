//
//  LocalPrayersTimes.swift
//  PrayersTimes
//
//  Created by Salah Amassi on 22/04/2021.
//

import Foundation

@dynamicMemberLookup
public struct LocalPrayersTimes: Equatable {
    
    private let prayers: Prayers
    public let day: Date
    
    public init(prayers: (fajr: Date,
                          sunrise: Date,
                          dhuhr: Date,
                          asr: Date,
                          sunset: Date,
                          maghrib: Date,
                          isha: Date,
                          imsak: Date,
                          midnight: Date),
                for day: Date) {
        self.prayers = Prayers(fajr: prayers.fajr,
                               sunrise: prayers.sunrise,
                               dhuhr: prayers.dhuhr,
                               asr: prayers.asr,
                               sunset: prayers.sunset,
                               maghrib: prayers.maghrib,
                               isha: prayers.isha,
                               imsak: prayers.imsak,
                               midnight: prayers.midnight)
        self.day = day
    }
    
    public subscript<T>(dynamicMember keyPath: KeyPath<Prayers, T>) -> T{
        prayers[keyPath: keyPath]
    }
}


