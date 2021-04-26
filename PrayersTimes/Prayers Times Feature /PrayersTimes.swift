//
//  PrayersTimes.swift
//  PrayersTimes
//
//  Created by Salah Amassi on 20/04/2021.
//

import Foundation

public struct PrayersTimes: Equatable {
    
    public let prayers: Prayers
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
}


