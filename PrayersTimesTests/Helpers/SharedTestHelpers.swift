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
