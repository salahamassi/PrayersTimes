//
//  SharedTestHelpers.swift
//  PrayersTimesTests
//
//  Created by Salah Amassi on 23/04/2021.
//

import Foundation

func anyNSError() -> NSError {
    .init(domain: "any error", code: 0)
}

func anyURL() -> URL {
    URL(string: "http://any-url.com")!
}

func getDate(from string: String, using date: Date) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    let fullDateString = dateFormatter.string(from: date)
    
    dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
    
    var stringResultDate = ""
    let splitResult = string.split(separator: " ")
    
    if let first = splitResult.first, let last = splitResult.last {
        dateFormatter.timeZone = TimeZone(abbreviation: String(last))
        stringResultDate.append(fullDateString)
        stringResultDate.append(" \(first):00")
        if let resultDate = dateFormatter.date(from: stringResultDate) {
            return resultDate
        }
    }
    fatalError("wrong string format \(string)")
}
