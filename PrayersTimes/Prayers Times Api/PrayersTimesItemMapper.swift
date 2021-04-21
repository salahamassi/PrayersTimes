//
//  PrayersTimesItemMapper.swift
//  PrayersTimes
//
//  Created by Salah Amassi on 21/04/2021.
//

import Foundation

final class PrayersTimesItemMapper {
    
    private struct Root: Decodable {
        
        let code: Int
        let status: String
        let data: [RemotePrayersTimes]
        
        var prayersTimes: [PrayersTimes] {
            data.map(\.prayerTime)
        }
    }
    
    static var OK_200: Int { return 200 }

    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [PrayersTimes] {
        guard response.statusCode == OK_200 else {
            throw RemotePrayersTimesLoader.Error.invalidData
        }

        let root = try JSONDecoder().decode(Root.self, from: data)
        return root.prayersTimes
    }
}
