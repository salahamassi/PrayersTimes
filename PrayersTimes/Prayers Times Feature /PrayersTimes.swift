//
//  PrayersTimes.swift
//  PrayersTimes
//
//  Created by Salah Amassi on 20/04/2021.
//

import Foundation

public struct Prayers: Equatable {
    
    private let fajr: Date
    private let sunrise: Date
    private let dhuhr: Date
    private let asr: Date
    private let sunset: Date
    private let maghrib: Date
    private let isha: Date
    private let imsak: Date
    private let midnight: Date
    
    public init(fajr: Date,
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
    
    public subscript(type: PrayerType) -> Date {
        get {
            return getPrayerDate(for: type)
        }
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


