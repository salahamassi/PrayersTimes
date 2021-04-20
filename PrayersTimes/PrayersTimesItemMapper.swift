//
//  PrayersTimesItemMapper.swift
//  PrayersTimes
//
//  Created by Salah Amassi on 21/04/2021.
//

import Foundation

class PrayersTimesItemMapper {
    
    private struct Root: Decodable {
        
        let code: Int
        let status: String
        let data: [RemotePrayersTimes]
        
        var prayersTimes: [PrayersTimes] {
            data.map(\.prayerTime)
        }
    }

    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [PrayersTimes] {
        guard response.statusCode == 200 else {
            throw RemotePrayersTimesLoader.Error.invalidData
        }

        let root = try JSONDecoder().decode(Root.self, from: data)
        return root.prayersTimes
    }

}

