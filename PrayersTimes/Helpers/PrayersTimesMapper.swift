//
//  PrayersTimesMapper.swift
//  PrayersTimes
//
//  Created by Salah Amassi on 25/04/2021.
//

import Foundation

/// This class mapping prayers times array items to a more readable and swifty type, using enum called "PrayersType" to detect every pray type and Foundation Date type to detect pray time instead of static string, so now the client can perform a calendrical calculations easily.
public class PrayersTimesMapper {
    
    public enum Error: Swift.Error {
        case invalidPrayerTime(Input)
    }
    
    public enum PrayersType {
        case fajr
        case sunrise
        case dhuhr
        case asr
        case sunset
        case maghrib
        case isha
        case imsak
        case midnight
    }
    
    public typealias Input = (time: String, type: PrayersType)
    public typealias Output = (date: Date, type: PrayersType)
    
    public static func map(_ prayersTimes: Input ..., using date: Date) throws -> [Output] {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let fullDateString = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        
        var results = [Output]()
        for prayerTime in prayersTimes {
            try map(prayerTime, dateFormatter, fullDateString, &results)
        }
        return results
    }
    
    private static func map(_ prayerTime: PrayersTimesMapper.Input, _ dateFormatter: DateFormatter, _ fullDateString: String, _ results: inout [(date: Date, type: PrayersTimesMapper.PrayersType)]) throws {
        let splitResult = prayerTime.time.split(separator: " ")
        var stringPrayerDate = ""
        if let first = splitResult.first, let last = splitResult.last {
            dateFormatter.timeZone = TimeZone(abbreviation: String(last))
            stringPrayerDate.append(fullDateString)
            stringPrayerDate.append(" \(first):00")
            guard let datePrayerTime = dateFormatter.date(from: stringPrayerDate)
            else { throw  Error.invalidPrayerTime(prayerTime) }
            results.append((date: datePrayerTime, type: prayerTime.type))
        } else {
            throw Error.invalidPrayerTime(prayerTime)
        }
    }
}
