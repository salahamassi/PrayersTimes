//
//  RemotePrayersTimes.swift
//  PrayersTimes
//
//  Created by Salah Amassi on 21/04/2021.
//

import Foundation

struct RemotePrayersTimes: Decodable {
    
    let timings: Timings
    let date: PrayersTimesDate
    
    var prayerTime: PrayersTimes {
        .init(fajr: timings.fajr,
              sunrise: timings.sunrise,
              dhuhr: timings.dhuhr,
              asr: timings.asr,
              sunset: timings.sunset,
              maghrib: timings.maghrib,
              isha: timings.isha,
              imsak: timings.imsak,
              midnight: timings.midnight,
              date: Date(timeIntervalSince1970: Double(date.timestamp) ?? 0.0))
    }

    struct Timings: Decodable {
        
        let fajr: String
        let sunrise: String
        let dhuhr: String
        let asr: String
        let sunset: String
        let maghrib: String
        let isha: String
        let imsak: String
        let midnight: String
        
        private enum CodingKeys: String, CodingKey {
            case fajr = "Fajr"
            case sunrise = "Sunrise"
            case dhuhr = "Dhuhr"
            case asr = "Asr"
            case sunset = "Sunset"
            case maghrib = "Maghrib"
            case isha = "Isha"
            case imsak = "Imsak"
            case midnight = "Midnight"
        }
    }
    struct PrayersTimesDate: Codable {
        let timestamp: String
    }
}
