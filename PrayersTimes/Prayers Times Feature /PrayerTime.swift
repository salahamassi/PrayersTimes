//
//  PrayerTime.swift
//  PrayersTimes
//
//  Created by Salah Amassi on 20/04/2021.
//

import Foundation

public struct PrayerTime: Equatable {
    
    public let fajr: String
    public let sunrise: String
    public let dhuhr: String
    public let asr: String
    public let sunset: String
    public let maghrib: String
    public let isha: String
    public let imsak: String
    public let midnight: String
    public let date: Date
    
    public init(fajr: String, sunrise: String, dhuhr: String, asr: String, sunset: String, maghrib: String, isha: String, imsak: String, midnight: String, date: Date) {
        self.fajr = fajr
        self.sunrise = sunrise
        self.dhuhr = dhuhr
        self.asr = asr
        self.sunset = sunset
        self.maghrib = maghrib
        self.isha = isha
        self.imsak = imsak
        self.midnight = midnight
        self.date = date
    }
}


