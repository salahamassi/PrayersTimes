//
//  Prayers.swift
//  PrayersTimes
//
//  Created by Salah Amassi on 26/04/2021.
//

import Foundation

public struct Prayers: Equatable {
    
    public struct Prayer {
        public let type: PrayerType
        public let date: Date
    }
    
    private let fajr: Date
    private let sunrise: Date
    private let dhuhr: Date
    private let asr: Date
    private let sunset: Date
    private let maghrib: Date
    private let isha: Date
    private let imsak: Date
    private let midnight: Date
    
    init(fajr: Date,
         sunrise: Date,
         dhuhr: Date,
         asr: Date,
         sunset: Date,
         maghrib: Date,
         isha: Date,
         imsak: Date,
         midnight: Date) {
        self.fajr = fajr
        self.sunrise = sunrise
        self.dhuhr = dhuhr
        self.asr = asr
        self.sunset = sunset
        self.maghrib = maghrib
        self.isha = isha
        self.imsak = imsak
        self.midnight = midnight
    }
    
    public subscript(type: PrayerType) -> Prayer {
        .init(type: type, date: getPrayerDate(for: type))
    }
    
    private func getPrayerDate(for type: PrayerType) -> Date {
        let prayerDate: Date
        switch type {
        case .fajr:
            prayerDate = fajr
        case .sunrise:
            prayerDate = sunrise
        case .dhuhr:
            prayerDate = dhuhr
        case .asr:
            prayerDate = asr
        case .sunset:
            prayerDate = sunset
        case .maghrib:
            prayerDate = maghrib
        case .isha:
            prayerDate = isha
        case .imsak:
            prayerDate = imsak
        case .midnight:
            prayerDate = midnight
        }
        return prayerDate
    }
}
